{ lib
, stdenv
, pythonAtLeast
, pythonOlder
<<<<<<< HEAD
, fetchFromGitHub
=======
, fetchPypi
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
, config

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
# CUDA-only dependencies:
, addOpenGLRunpath ? null
, cudaPackages ? {}

# CUDA flags:
<<<<<<< HEAD
, cudaSupport ? config.cudaSupport
=======
, cudaSupport ? false
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let
  inherit (cudaPackages) cudatoolkit;
in buildPythonPackage rec {
<<<<<<< HEAD
  # Using an untagged version, with numpy 1.25 support, when it's released
  # also drop the versioneer patch in postPatch
  version = "unstable-2023-08-11";
=======
  version = "0.56.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "numba";
  format = "setuptools";
  disabled = pythonOlder "3.6" || pythonAtLeast "3.11";

<<<<<<< HEAD
  src = fetchFromGitHub {
    owner = "numba";
    repo = "numba";
    rev = "6f0c5060a69656319ab0bae1d8bb89484cd5631f";
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
    hash = "sha256-34qEn/i2X6Xu1cjuiRrmrm/HryNoN+Am4A4pJ90srAE=";
  };
=======
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

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  patches = lib.optionals cudaSupport [
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    (substituteAll {
      src = ./cuda_path.patch;
      cuda_toolkit_path = cudatoolkit;
      cuda_toolkit_lib_path = cudatoolkit.lib;
    })
  ];
<<<<<<< HEAD
  # with untagged version we need to specify the correct version ourselves

  postPatch = ''
    substituteInPlace setup.py --replace "version=versioneer.get_version()" "version='0.57.1'"
    substituteInPlace numba/_version.py \
      --replace 'git_refnames = " (HEAD -> main)"' 'git_refnames = "tag: 0.57.1"'
  '';
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    mainProgram = "numba";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ fridh ];
  };
}
