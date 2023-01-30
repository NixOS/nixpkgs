{ lib
, buildPythonPackage
, fetchFromGitHub
, parameterized
, pycryptodome
, pydantic
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
  version = "1.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-e+neyzH+sGTzGwdy/N7n6GUvctHlHQgwDkRQsnzL7Jw=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov=pyrainbird --cov-report=term-missing" ""

    substituteInPlace setup.cfg \
      --replace "pycryptodome>=3.16.0" "pycryptodome"
  '';

  propagatedBuildInputs = [
    pycryptodome
    pydantic
    pyyaml
    requests
  ];

  nativeCheckInputs = [
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
    homepage = "https://github.com/allenporter/pyrainbird";
    changelog = "https://github.com/allenporter/pyrainbird/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
