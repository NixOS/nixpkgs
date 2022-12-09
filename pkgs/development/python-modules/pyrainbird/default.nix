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
  version = "0.6.3";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jbarrancos";
    repo = pname;
    rev = version;
    hash = "sha256-yGUBCs1IxbGKBo21gExFIqDawM2EHlO+jiRqonEUnPk=";
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
