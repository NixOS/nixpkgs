{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  setuptools,
  aiohttp,
  audioop-lts,
  curl-cffi,
  davey,
  discord-protos,
  pynacl,
  tzlocal,
}:

buildPythonPackage {
  pname = "discord-py-self";
  version = "2.1.0-unstable-2026-10-10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dolfies";
    repo = "discord.py-self";
    rev = "2ba64a9a997e151a9c259984e0a179b1fdf4aff4";
    hash = "sha256-3SzDET0R+x79pmzPL8FEWYHfKG43ySEZlmQ+3spErhg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    curl-cffi
    discord-protos
    tzlocal
  ]
  ++ lib.optional (pythonAtLeast "3.13") audioop-lts;

  optional-dependencies.voice = [
    davey
    pynacl
  ];

  pythonRelaxDeps = [ "curl_cffi" ];

  pythonImportsCheck = [ "discord" ];

  meta = {
    description = "Python wrapper for the Discord user API";
    homepage = "https://github.com/dolfies/discord.py-self";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ epwv ];
  };
}
