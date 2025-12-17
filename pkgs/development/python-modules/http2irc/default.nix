{
  lib,
  fetchFromGitea,
  buildPythonPackage,
  setuptools,
  aiohttp,
  ircstates,
  toml,
}:

buildPythonPackage rec {
  pname = "http2irc";
  version = "0-unstable-2025-12-19";

  src = fetchFromGitea {
    domain = "gitea.arpa.li";
    owner = "ArchiveTeam";
    repo = pname;
    rev = "b300d8230a57d0430181bf902a684d7b901f3043";
    hash = "sha256-MN2jyETPD+52WMRA8UUZulQgybWY0zh3Re97e16jKpI=";
  };

  prePatch = ''
    cat ${./pyproject.toml} >pyproject.toml
    mkdir http2irc
    mv contrib http2irc/
    cat ${./async_wrapper.py} >http2irc/async_wrapper.py
    mv http2irc.py http2irc/__init__.py
  '';
  # do not run tests
  #doCheck = false;

  dependencies = [
    aiohttp
    ircstates
    toml
  ];

  pyproject = true;
  build-system = [
    setuptools
  ];

  meta = {
    description = "HTTP API to interact with IRC";
    license = lib.licenses.agpl3Plus;
    mainProgram = "http2irc";
    maintainers = with lib.maintainers; [ klea ];
  };
}
