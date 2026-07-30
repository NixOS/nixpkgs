{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
  python,
  setuptools,
  setuptools-scm,
  which,
}:

buildPythonPackage rec {
  pname = "nodeenv";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ekalinin";
    repo = "nodeenv";
    tag = version;
    hash = "sha256-CosZOTWxXFGrc2ZvPPUwFcUv1blZhyl8MWPnoRCpBBo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  preFixup = ''
    substituteInPlace $out/${python.sitePackages}/nodeenv.py \
      --replace '["which", candidate]' '["${lib.getBin which}/bin/which", candidate]'
  '';

  pythonImportsCheck = [ "nodeenv" ];

  disabledTests = [
    # Test requires coverage
    "test_smoke"
  ];

  meta = {
    description = "Node.js virtual environment builder";
    mainProgram = "nodeenv";
    homepage = "https://github.com/ekalinin/nodeenv";
    changelog = "https://github.com/ekalinin/nodeenv/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
