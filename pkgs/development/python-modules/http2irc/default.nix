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
  version = "0-unstable-2025-01-05";

  src = fetchFromGitea {
    domain = "gitea.arpa.li";
    owner = "ArchiveTeam";
    repo = pname;
    rev = "34bbc96000450afb935add13dfa5c08269d56afa";
    hash = "sha256-IFq3r2IxmZxGT8WYKPTM96smRxi2jwOlri+EHqB5xsc=";
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
