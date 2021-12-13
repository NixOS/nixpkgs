{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, poetry-core
, pytest-asyncio
, pytest-httpx
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "glances-api";
  version = "0.3.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-glances-api";
    rev = version;
    sha256 = "sha256-zVK63SI8ZeVrY2iEEkgp8pq6RDheKeApb9/RWgZCKGI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    httpx
  ];

  checkInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'httpx = ">=0.20,<1"' 'httpx = ">=0.19,<1"'
  '';

  pythonImportsCheck = [
    "glances_api"
  ];

  meta = with lib; {
    description = "Python API for interacting with Glances";
    homepage = "https://github.com/home-assistant-ecosystem/python-glances-api";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
