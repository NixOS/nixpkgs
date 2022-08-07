{ lib
, buildPythonPackage
, fetchFromGitHub
, parameterized
, pycryptodome
, pytestCheckHook
, pythonOlder
, pyyaml
, requests
, responses
, setuptools
}:

buildPythonPackage rec {
  pname = "pyrainbird";
  version = "0.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jbarrancos";
    repo = pname;
    rev = version;
    hash = "sha256-uRHknWvoPKPu3B5MbSEUlWqBKwAbNMwsgXuf6PZxhkU=";
  };

  propagatedBuildInputs = [
    pycryptodome
    pyyaml
    requests
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
    parameterized
    responses
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "datetime" ""
    substituteInPlace pytest.ini \
      --replace "--cov=pyrainbird --cov-report=term-missing --pep8 --flakes --mccabe" ""
  '';

  pythonImportsCheck = [
    "pyrainbird"
  ];

  meta = with lib; {
    description = "Module to interact with Rainbird controllers";
    homepage = "https://github.com/jbarrancos/pyrainbird/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
