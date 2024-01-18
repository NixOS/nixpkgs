{ lib
, aiohttp
, aresponses
, backoff
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
  version = "0.5.16";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "liudger";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-m80lnNd1ANddV0d/w3S7+QWzIPRklDZsWMO2g1hgEoQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"' \
      --replace "--cov" ""
    sed -i "/covdefaults/d" pyproject.toml
    sed -i "/ruff/d" pyproject.toml
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    backoff
    packaging
    pydantic
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = lib.optionals (lib.versionAtLeast aiohttp.version "3.9.0") [
    # https://github.com/liudger/python-bsblan/issues/808
    "test_http_error400"
    "test_not_authorized_401_response"
  ];

  pythonImportsCheck = [
    "bsblan"
  ];

  meta = with lib; {
    description = "Module to control and monitor an BSBLan device programmatically";
    homepage = "https://github.com/liudger/python-bsblan";
    changelog = "https://github.com/liudger/python-bsblan/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
