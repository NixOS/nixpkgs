{ lib
, buildPythonPackage
, fetchFromGitHub
, parameterized
, pycryptodome
, pytestCheckHook
, pythonOlder
, pyyaml
, requests
, requests-mock
, responses
}:

buildPythonPackage rec {
  pname = "pyrainbird";
  version = "0.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jbarrancos";
    repo = pname;
    rev = version;
    hash = "sha256-MikJDW5Fo2DNpn9/Hyc1ecIIMEwE8GD5LKpka2t7aCk=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov=pyrainbird --cov-report=term-missing" ""
  '';

  propagatedBuildInputs = [
    pycryptodome
    pyyaml
    requests
  ];

  checkInputs = [
    parameterized
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
