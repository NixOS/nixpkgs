{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pydantic
, pytestCheckHook
, pytest-asyncio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytraccar";
  version = "2.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = version;
    hash = "sha256-7QGgI+DDYbordBx4LbtCvPWyEh6ur2RrSKMuDlwRlTo=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pydantic
  ];

  nativeCheckInputs = [
    aresponses
    pytestCheckHook
    pytest-asyncio
  ];

  pytestFlagsArray = [
    "--asyncio-mode=auto"
  ];

  postPatch = ''
    # Upstream doesn't set version in the repo
    substituteInPlace pyproject.toml \
      --replace 'version = "0"' 'version = "${version}"'
  '';

  pythonImportsCheck = [
    "pytraccar"
  ];

  meta = with lib; {
    description = "Python library to handle device information from Traccar";
    homepage = "https://github.com/ludeeus/pytraccar";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
