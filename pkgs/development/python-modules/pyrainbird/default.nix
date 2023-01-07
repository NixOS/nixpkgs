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
, pydantic
, requests-mock
, responses
}:

buildPythonPackage rec {
  pname = "pyrainbird";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-5IEzoxuwIzMfHzW0oD/LC+iWf+yC05nfCJd5tzMccrc=";
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

  nativeCheckInputs = [
    parameterized
    pytest-aiohttp
    pytestCheckHook
    requests-mock
    responses
    pydantic
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
