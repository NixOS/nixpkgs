{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pytest-asyncio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytraccar";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = "pytraccar";
    rev = "refs/tags/${version}";
    hash = "sha256-7QGgI+DDYbordBx4LbtCvPWyEh6ur2RrSKMuDlwRlTo=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # https://github.com/ludeeus/pytraccar/issues/31
  doCheck = lib.versionOlder aiohttp.version "3.9.0";

  nativeCheckInputs = [
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
    changelog = "https://github.com/ludeeus/pytraccar/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
