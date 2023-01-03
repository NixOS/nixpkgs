{ lib
, buildPythonPackage
, fetchFromGitHub
, parameterized
, pycryptodome
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, pyyaml
, requests
, requests-mock
, responses
}:

buildPythonPackage rec {
  pname = "pyrainbird";
  version = "0.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jbarrancos";
    repo = pname;
    rev = version;
    hash = "sha256-pN/QILpXJoQAccB7CSDLxCDYfijf/VJbYw+NRUI4kvs=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov=pyrainbird --cov-report=term-missing" ""

    substituteInPlace setup.cfg \
      --replace "pycryptodome>=3.16.0" "pycryptodome"
  '';

  propagatedBuildInputs = [
    pycryptodome
    pyyaml
    requests
  ];

  checkInputs = [
    parameterized
    pytest-aiohttp
    pytestCheckHook
    requests-mock
    responses
  ];

  pythonImportsCheck = [
    "pyrainbird"
  ];

  meta = with lib; {
    description = "Module to interact with Rainbird controllers";
    homepage = "https://github.com/jbarrancos/pyrainbird/";
    changelog = "https://github.com/jbarrancos/pyrainbird/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
