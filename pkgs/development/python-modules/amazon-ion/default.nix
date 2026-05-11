{
  lib,
  buildPythonPackage,
  cbor2,
  docopt,
  fetchFromGitHub,
  fetchpatch2,
  jsonconversion,
  pytestCheckHook,
  pytest_7,
  setuptools,
  six,
  tabulate,
  cmake,
}:

buildPythonPackage rec {
  pname = "amazon-ion";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amazon-ion";
    repo = "ion-python";
    tag = "v${version}";
    # Test vectors require git submodule
    fetchSubmodules = true;
    leaveDotGit = true; # During ion-c submodule build git history/hash used to infer version
    postFetch = ''
      # Generated file should match output of command in ion-c/cmake/VersionHeader.cmake
      # Run Git before creating any files to avoid triggering false dirty suffix.
      (cd "$out/ion-c" && v="$(git describe --long --tags --dirty --match "v*")" && echo -n "$v" > .nixpkgs-patching-IONC_FULL_VERSION.txt)

      # Based on https://github.com/NixOS/nixpkgs/blob/183125f9/pkgs/build-support/fetchgit/nix-prefetch-git#L358
      find "$out" -name .git -exec rm -rf '{}' '+'
    '';
    hash = "sha256-VBbxGXPAwS3jwEsm64yEKqJKVKGvPStboLjHoRcoonE=";
  };

  patches = [
    # backport changes that adapt code to more strict compilers
    (fetchpatch2 {
      name = "46aebb0-Address-incompatible-pointer-errors.patch";
      url = "https://github.com/amazon-ion/ion-c/commit/46aebb0b650a4cf61425ef1a8e78e2443023e853.patch?full_index=1";
      hash = "sha256-5qzSbZV9Oe5soJzkyCtVtWejedLEjAz7yuVotATPmbs=";
      stripLen = 1;
      extraPrefix = "ion-c/";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""

    # Ion C building is in _download_ion_c() which will try to remove sources and re-download
    substituteInPlace install.py \
      --replace-fail "isdir(_CURRENT_ION_C_DIR)" "False"
    substituteInPlace install.py \
      --replace-fail "check_call(['git'" "check_call(['true'"

    # Ion-C infers version based on Git. But there are issues with making .git folders deterministic.
    # See https://github.com/NixOS/nixpkgs/issues/8567
    # Hence, we'll inject version ourselves
    substituteInPlace ion-c/cmake/VersionHeader.cmake \
      --replace-fail 'set(IONC_FULL_VERSION "''${CMAKE_PROJECT_VERSION}")' \
                     "set(IONC_FULL_VERSION \"$(cat ion-c/.nixpkgs-patching-IONC_FULL_VERSION.txt)\")"
  '';

  build-system = [
    setuptools
  ];

  dontUseCmakeConfigure = true; # CMake invoked by install.py

  # Can't use cmakeFlags since we do not control invocation of cmake.
  # But build-release.sh in ion-c is sensitive to this env variable.
  env.CMAKE_FLAGS = "-DCMAKE_SKIP_BUILD_RPATH=ON";

  nativeBuildInputs = [
    cmake
  ];

  dependencies = [
    jsonconversion
    six
  ];

  nativeCheckInputs = [
    cbor2
    docopt
    (pytestCheckHook.override { pytest = pytest_7; })
    tabulate
  ];

  disabledTests = [
    # ValueError: Exceeds the limit (4300) for integer string conversion
    "test_roundtrips"
  ];

  disabledTestPaths = [
    # Exclude benchmarks
    "tests/test_benchmark_cli.py"
  ];

  pythonImportsCheck = [
    "amazon.ion"
    "amazon.ion.ionc" # C extension module for speedup
  ];

  meta = {
    description = "Python implementation of Amazon Ion";
    homepage = "https://github.com/amazon-ion/ion-python";
    changelog = "https://github.com/amazon-ion/ion-python/releases/tag/${src.tag}";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ terlar ];
  };
}
