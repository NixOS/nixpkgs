{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pytest-asyncio,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pytraccar";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = "pytraccar";
    tag = version;
    hash = "sha256-DtxZCvLuvQpbu/1lIXz2BVbACt5Q1N2txVMyqwd4d9A=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ aiohttp ];

  # https://github.com/ludeeus/pytraccar/issues/31
  doCheck = lib.versionOlder aiohttp.version "3.9.0";

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pytestFlags = [ "--asyncio-mode=auto" ];

  postPatch = ''
    # Upstream doesn't set version in the repo
    substituteInPlace pyproject.toml \
      --replace 'version = "0"' 'version = "${version}"'
  '';

  pythonImportsCheck = [ "pytraccar" ];

  meta = with lib; {
    description = "Python library to handle device information from Traccar";
    homepage = "https://github.com/ludeeus/pytraccar";
    changelog = "https://github.com/ludeeus/pytraccar/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
