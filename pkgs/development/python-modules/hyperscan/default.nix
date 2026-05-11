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
buildPythonPackage rec {
  pname = "hyperscan";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darvid";
    repo = "python-hyperscan";
    tag = "v${version}";
    hash = "sha256-on++eSNaVY2Q6yT/O+unvE0x/Pt/SsIQFQblIqii2sM=";
  };

  env.CMAKE_ARGS = "-DHS_SRC_ROOT=${pkgs.hyperscan.src} -DHS_BUILD_LIB_ROOT=${lib-deps}/lib";

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
    changelog = "https://github.com/darvid/python-hyperscan/blob/${src.tag}/CHANGELOG.md";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
