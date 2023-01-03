{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
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
  pname = "python-bsblan";
  version = "0.5.8";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "liudger";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pLqX+gbY71OsLflTyDuL4revj5dXol//eTFVy8iT9O4=";
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
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"' \
      --replace "--cov" ""
  '';

  pythonImportsCheck = [
    "bsblan"
  ];

  meta = with lib; {
    description = "Module to control and monitor an BSBLan device programmatically";
    homepage = "https://github.com/liudger/python-bsblan";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
