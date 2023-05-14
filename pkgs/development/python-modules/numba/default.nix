{ lib
, stdenv
, pythonAtLeast
, pythonOlder
, fetchPypi
, python
, buildPythonPackage
, setuptools
, numpy
, llvmlite
, libcxx
, importlib-metadata
, substituteAll
, runCommand
, fetchpatch

# CUDA-only dependencies:
, addOpenGLRunpath ? null
, cudaPackages ? {}

# CUDA flags:
, cudaSupport ? false
}:

let
  inherit (cudaPackages) cudatoolkit;
in buildPythonPackage rec {
  version = "0.56.4";
  pname = "numba";
  format = "setuptools";
  disabled = pythonOlder "3.6" || pythonAtLeast "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Mtn+9BLIFIPX7+DOts9NMxD96LYkqc7MoA95BXOslu4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'max_numpy_run_version = "1.24"' 'max_numpy_run_version = "1.25"'
    substituteInPlace numba/__init__.py \
      --replace "elif numpy_version > (1, 23):" "elif numpy_version > (1, 24):"
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-I${lib.getDev libcxx}/include/c++/v1";

  nativeBuildInputs = [
    numpy
  ] ++ lib.optionals cudaSupport [
    addOpenGLRunpath
  ];

  propagatedBuildInputs = [
    numpy
    llvmlite
    setuptools
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-metadata
  ] ++ lib.optionals cudaSupport [
    cudatoolkit
    cudatoolkit.lib
  ];

  patches = [
    # fix failure in test_cache_invalidate (numba.tests.test_caching.TestCache)
    # remove when upgrading past version 0.56
    (fetchpatch {
      name = "fix-test-cache-invalidate-readonly.patch";
      url = "https://github.com/numba/numba/commit/993e8c424055a7677b2755b184fc9e07549713b9.patch";
      hash = "sha256-IhIqRLmP8gazx+KWIyCxZrNLMT4jZT8CWD3KcH4KjOo=";
    })
    # Backport numpy 1.24 support from https://github.com/numba/numba/pull/8691
    ./numpy-1.24.patch
  ] ++ lib.optionals cudaSupport [
    (substituteAll {
      src = ./cuda_path.patch;
      cuda_toolkit_path = cudatoolkit;
      cuda_toolkit_lib_path = cudatoolkit.lib;
    })
  ];

  postFixup = lib.optionalString cudaSupport ''
    find $out -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      addOpenGLRunpath "$lib"
      patchelf --set-rpath "${cudatoolkit}/lib:${cudatoolkit.lib}/lib:$(patchelf --print-rpath "$lib")" "$lib"
    done
  '';

  # run a smoke test in a temporary directory so that
  # a) Python picks up the installed library in $out instead of the build files
  # b) we have somewhere to put $HOME so some caching tests work
  # c) it doesn't take 6 CPU hours for the full suite
  checkPhase = ''
    runHook preCheck

    pushd $(mktemp -d)
    HOME=. ${python.interpreter} -m numba.runtests -m $NIX_BUILD_CORES numba.tests.test_usecases
    popd

    runHook postCheck
  '';

  pythonImportsCheck = [
    "numba"
  ];

  passthru.tests = {
    # CONTRIBUTOR NOTE: numba also contains CUDA tests, though these cannot be run in
    # this sandbox environment. Consider running similar commands to those below outside the
    # sandbox manually if you have the appropriate hardware; support will be detected
    # and the corresponding tests enabled automatically.
    # Also, the full suite currently does not complete on anything but x86_64-linux.
    fullSuite = runCommand "${pname}-test" {} ''
      pushd $(mktemp -d)
      # pip and python in $PATH is needed for the test suite to pass fully
      PATH=${python.withPackages (p: [ p.numba p.pip ])}/bin:$PATH
      HOME=$PWD python -m numba.runtests -m $NIX_BUILD_CORES
      popd
      touch $out # stop Nix from complaining no output was generated and failing the build
    '';
  };

  meta =  with lib; {
    description = "Compiling Python code using LLVM";
    homepage = "https://numba.pydata.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fridh ];
  };
}
