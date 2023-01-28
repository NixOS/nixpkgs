{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, aiohttp
, async-timeout
, yarl
, aresponses
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "here-routing";
  version = "0.2.0";

  disabled = pythonOlder "3.8";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "eifinger";
    repo = "here_routing";
    rev = "v${version}";
    hash = "sha256-IXiYLDrPXc6YT8u0QT6f2GAjBNYhWwzkFxGhmAyiq5s=";
  };

  postPatch = ''
    sed -i "/^addopts/d" pyproject.toml
  '';

  nativeBuildInputs = [
    poetry-core
  ];

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
