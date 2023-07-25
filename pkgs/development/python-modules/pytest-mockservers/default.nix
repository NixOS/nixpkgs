{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, aiohttp
, pytest
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-mockservers";
  version = "0.6.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Gr1N";
    repo = pname;
    rev = version;
    sha256 = "0xql0fnw7m2zn103601gqbpyd761kzvgjj2iz9hjsv56nr4z1g9i";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    aiohttp
    pytest-asyncio
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_mockservers"
  ];

  meta = with lib; {
    description = "A set of fixtures to test your requests to HTTP/UDP servers";
    homepage = "https://github.com/Gr1N/pytest-mockservers";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
