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
  version = "1.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ekalinin";
    repo = pname;
    rev = version;
    hash = "sha256-X30PUiOMT/vXqmdSJKHTNNA8aLWavCUaKa7LzqkdLrk=";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  checkInputs = [
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
