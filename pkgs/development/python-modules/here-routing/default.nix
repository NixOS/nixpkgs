{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  aiohttp,
  async-timeout,
  yarl,
  aresponses,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "here-routing";
  version = "1.0.0";

  disabled = pythonOlder "3.10";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "eifinger";
    repo = "here_routing";
    rev = "v${version}";
    hash = "sha256-wdjPbM9J+2q3NisdlOHIddSWHHIfwQY/83v6IBAXSq0=";
  };

  postPatch = ''
    sed -i "/^addopts/d" pyproject.toml
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "here_routing" ];

  meta = {
    changelog = "https://github.com/eifinger/here_routing/blob/${src.rev}/CHANGELOG.md";
    description = "Asynchronous Python client for the HERE Routing V8 API";
    homepage = "https://github.com/eifinger/here_routing";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
