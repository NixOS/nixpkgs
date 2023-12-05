{ lib
, stdenv
, pythonAtLeast
, pythonOlder
, fetchFromGitHub
, python
, buildPythonPackage
, setuptools
, numpy
, llvmlite
, libcxx
, importlib-metadata
, substituteAll
, runCommand

, config

# CUDA-only dependencies:
, addOpenGLRunpath ? null
, cudaPackages ? {}

# CUDA flags:
, cudaSupport ? config.cudaSupport
}:

let
  inherit (cudaPackages) cudatoolkit;
in buildPythonPackage rec {
  # Using an untagged version, with numpy 1.25 support, when it's released
  # also drop the versioneer patch in postPatch
  version = "0.58.1";
  pname = "numba";
  pyproject = true;

  disabled = pythonOlder "3.8" || pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "numba";
    repo = "numba";
    rev = "refs/tags/${version}";
    # Upstream uses .gitattributes to inject information about the revision
    # hash and the refname into `numba/_version.py`, see:
    #
    # - https://git-scm.com/docs/gitattributes#_export_subst and
    # - https://github.com/numba/numba/blame/5ef7c86f76a6e8cc90e9486487294e0c34024797/numba/_version.py#L25-L31
    #
    # Hence this hash may change if GitHub / Git will change it's behavior.
    # Hopefully this will not happen until the next release. We are fairly sure
    # that upstream relies on those strings to be valid, that's why we don't
    # use `forceFetchGit = true;`.` If in the future we'll observe the hash
    # changes too often, we can always use forceFetchGit, and inject the
    # relevant strings ourselves, using `sed` commands, in extraPostFetch.
    hash = "sha256-1Tj2GFoUwRRCWBFxhreF+0Mr+Tjyb7+X4peO+T0qGNs=";
  };
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

  patches = lib.optionals cudaSupport [
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
    mainProgram = "numba";
    maintainers = with maintainers; [ fridh ];
  };
}
