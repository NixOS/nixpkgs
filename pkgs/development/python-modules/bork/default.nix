{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

, build
, coloredlogs
, packaging
, toml
, twine
, wheel
}:

buildPythonPackage rec {
  pname = "bork";
  version = "7.0.1";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "duckinator";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-y/p2uuU+QKgJSdJmMt3oebm/zcuatYWTW8Jl79YxA3g=";
  };

  propagatedBuildInputs = [
    build
    coloredlogs
    packaging
    toml
    twine
    wheel
  ];

  pythonImportsCheck = [
    "bork"
    "bork.api"
    "bork.cli"
  ];

  meta = with lib; {
    description = "Python build and release management tool";
    homepage = "https://github.com/duckinator/bork";
    maintainers = with maintainers; [ nicoo ];
    platforms = platforms.all;
  };
}
