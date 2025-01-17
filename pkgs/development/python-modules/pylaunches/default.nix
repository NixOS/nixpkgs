{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pytest-asyncio,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pylaunches";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = "pylaunches";
    tag = version;
    hash = "sha256-NewzzZuiXwaWU59bu+M2QcSfydL1khvw/YJkbZ58W2Q=";
  };

  postPatch = ''
    # Upstream doesn't set version in the repo
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0"' 'version = "${version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aresponses
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "pylaunches" ];

  meta = with lib; {
    description = "Python module to get information about upcoming space launches";
    homepage = "https://github.com/ludeeus/pylaunches";
    changelog = "https://github.com/ludeeus/pylaunches/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
