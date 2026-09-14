{
  lib,
  buildPythonPackage,
  cbor2,
  docopt,
  fetchFromGitHub,
  jsonconversion,
  py-build-cmake,
  pytestCheckHook,
  tabulate,
}:

buildPythonPackage (finalAttrs: {
  pname = "amazon-ion";
  version = "0.14.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amazon-ion";
    repo = "ion-python";
    tag = "v${finalAttrs.version}";
    # Test vectors require git submodule
    fetchSubmodules = true;
    leaveDotGit = true; # During ion-c submodule build git history/hash used to infer version
    postFetch = ''
      # Generated file should match output of command in src/ion-c/cmake/VersionHeader.cmake
      # Run Git before creating any files to avoid triggering false dirty suffix.
      (cd "$out/src/ion-c" && v="$(git describe --long --tags --dirty --match "v*")" && echo -n "$v" > .nixpkgs-patching-IONC_FULL_VERSION.txt)

      # Based on https://github.com/NixOS/nixpkgs/blob/183125f9/pkgs/build-support/fetchgit/nix-prefetch-git#L358
      find "$out" -name .git -exec rm -rf '{}' '+'
    '';
    hash = "sha256-W4QhRhQEHUlRAS8kYe/GxHawyj5tj6v3BHb9mEdMYL8=";
  };

  postPatch = ''
    # Ion-C infers version based on Git. But there are issues with making .git folders deterministic.
    # See https://github.com/NixOS/nixpkgs/issues/8567
    # Hence, we'll inject version ourselves
    substituteInPlace src/ion-c/CMakeLists.txt \
      --replace-fail 'set(IONC_FULL_VERSION "v''${CMAKE_PROJECT_VERSION}-0-g000000")' \
                     "set(IONC_FULL_VERSION \"$(cat src/ion-c/.nixpkgs-patching-IONC_FULL_VERSION.txt)\")"
  '';

  build-system = [
    py-build-cmake
  ];

  dependencies = [
    jsonconversion
  ];

  nativeCheckInputs = [
    cbor2
    docopt
    pytestCheckHook
    tabulate
  ];

  disabledTestPaths = [
    # Exclude benchmarks
    "tests/test_benchmark*.py"
  ];

  pythonImportsCheck = [
    "amazon.ion"
    "amazon._ioncmodule" # C extension module for speedup
  ];

  meta = {
    description = "Python implementation of Amazon Ion";
    homepage = "https://github.com/amazon-ion/ion-python";
    changelog = "https://github.com/amazon-ion/ion-python/releases/tag/${finalAttrs.src.tag}";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ terlar ];
  };
})
