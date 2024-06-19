{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
  python,
  pythonOlder,
  setuptools,
  setuptools-scm,
  which,
}:

buildPythonPackage rec {
  pname = "nodeenv";
  version = "1.9.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ekalinin";
    repo = "nodeenv";
    rev = "refs/tags/${version}";
    hash = "sha256-85Zr4RbmNeW3JAdtvDblWaPTivWWUJKh+mJbtsGJVO4=";
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

  meta = with lib; {
    description = "Node.js virtual environment builder";
    mainProgram = "nodeenv";
    homepage = "https://github.com/ekalinin/nodeenv";
    changelog = "https://github.com/ekalinin/nodeenv/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
