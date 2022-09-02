{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, mypy
, packaging
, poetry-core
, pydantic
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "bsblan";
  version = "0.5.5";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "liudger";
    repo = "python-bsblan";
    rev = "v${version}";
    hash = "sha256-kq4cML7D9XC/QRPjGfaWcs0H78OOc2IXGua7qJpWYOQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    packaging
    pydantic
    yarl
  ];

  checkInputs = [
    aresponses
    mypy
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"' \
      --replace "--cov" ""
  '';

  pythonImportsCheck = [
    "bsblan"
  ];

  meta = with lib; {
    description = "Python client for BSB-Lan";
    homepage = "https://github.com/liudger/python-bsblan";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
