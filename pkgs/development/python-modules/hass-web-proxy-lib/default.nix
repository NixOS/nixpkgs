{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  home-assistant,
  lib,
  mypy,
  poetry-core,
  pytest-aiohttp,
  pytest-asyncio,
  pytest-cov,
  pytest-homeassistant-custom-component,
  pytest-socket,
  pytest-timeout,
  pytest,
  requests-mock,
  respx,
  syrupy,
  toPythonModule,
}:

buildPythonPackage {
  pname = "hass-web-proxy-lib";
  version = "0.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dermotduffy";
    repo = "hass-web-proxy-lib";
    rev = "f96dfdec6e24275dc83b462a3471d89509f3d42a";
    hash = "sha256-RJ7XUkgutgnbwZnmV7jtt+Hit7ZM/08hNZWTTEARlNc=";
  };

  build-system = [ poetry-core ];

  meta = {
    description = "Home Assistant Web Proxy Library ";
    homepage = "https://github.com/dermotduffy/hass-web-proxy-lib";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nealfennimore ];
  };

  buildInputs = [
    (toPythonModule home-assistant)
    aiohttp
    freezegun
    mypy
    pytest
    pytest-aiohttp
    pytest-asyncio
    pytest-cov
    pytest-homeassistant-custom-component
    pytest-socket
    pytest-timeout
    requests-mock
    respx
    syrupy
  ];

  checkPhase = ''
    runHook preCheck
    ${pytest}/bin/pytest -p no:sugar
    runHook postCheck
  '';
}
