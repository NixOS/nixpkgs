{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, python
, pythonOlder
, setuptools
, which
}:

buildPythonPackage rec {
  pname = "nodeenv";
  version = "1.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ekalinin";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-aW/aNZbFXfP4bF/Nlvv419IDfaJRA1pJYM7awj+6Hz0=";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  preFixup = ''
    substituteInPlace $out/${python.sitePackages}/nodeenv.py \
      --replace '["which", candidate]' '["${lib.getBin which}/bin/which", candidate]'
  '';

  pythonImportsCheck = [
    "nodeenv"
  ];

  disabledTests = [
    # Test requires coverage
    "test_smoke"
  ];

  meta = with lib; {
    description = "Node.js virtual environment builder";
    homepage = "https://github.com/ekalinin/nodeenv";
    changelog = "https://github.com/ekalinin/nodeenv/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
