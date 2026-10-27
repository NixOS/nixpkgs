{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pkgs,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydig";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "leonsmith";
    repo = "pydig";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bNGqIEGPcd/TSTSDs2nGxBh60QI7sXRX9A0NVYflqPc=";
  };

  patches = [
    # Switch to poetry-core, https://github.com/leonsmith/pydig/pull/21
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/leonsmith/pydig/commit/6e8ad99494b16084974c799db9afa020f1741886.patch";
      hash = "sha256-KhVQICsR93n+EuCcGhj81lChB/gBSQWncg1PYyo0dlc=";
    })
  ];

  build-system = [ poetry-core ];

  dependencies = [ pkgs.dig ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pydig" ];

  meta = {
    description = "Python wrapper library for the 'dig' command line tool";
    homepage = "https://github.com/leonsmith/pydig";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
