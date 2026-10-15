{
  lib,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,
  symlinkJoin,
  cmake,
  ninja,
  pathspec,
  pcre,
  scikit-build-core,
  pytestCheckHook,
  pytest-mock,
}:
let
  lib-deps = symlinkJoin {
    name = "hyperscan-static-deps";
    paths = [
      (pkgs.hyperscan.override { withStatic = true; })
      (pcre.overrideAttrs { dontDisableStatic = 0; }).out
    ];
  };
in
buildPythonPackage (finalAttrs: {
  pname = "hyperscan";
  version = "0.8.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "darvid";
    repo = "python-hyperscan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jIDUfl6ReWvypfWecM8hReux6YxzXSsLCFU3AO97xUY=";
  };

  env.CMAKE_ARGS = lib.toString [
    (lib.cmakeFeature "HS_SRC_ROOT" pkgs.hyperscan.src.outPath)
    (lib.cmakeFeature "HS_BUILD_LIB_ROOT" "${lib-deps}/lib")
  ];

  dontUseCmakeConfigure = true;

  build-system = [
    cmake
    pathspec
    ninja
    scikit-build-core
  ];

  pythonImportsCheck = [ "hyperscan" ];

  enabledTestPaths = [ "tests" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  meta = {
    description = "CPython extension for the Hyperscan regular expression matching library";
    homepage = "https://github.com/darvid/python-hyperscan";
    changelog = "https://github.com/darvid/python-hyperscan/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    platforms = [
      "x86_64-linux"
    ];
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
