{
  stdenv,
  fetchFromGitHub,
  hostname,
  rsync,
  zip,
  curl,
  python3,
  lib,
}:
stdenv.mkDerivation rec {
  name = "elm-wrap";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "dsimunic";
    repo = "elm-wrap";
    tag = "v${version}";
    hash = "sha256-n7wX2jP4sX2LYiiFKOIyrEw5B4eJB9Bp2JD4qpp9Kmw=";
  };

  nativeBuildInputs = [
    hostname
    rsync
    zip
  ];

  buildInputs = [
    curl
  ];

  nativeCheckInputs = [
    python3
  ];

  doCheck = true;
  checkPhase = "make test";

  buildFlags = [ "RELEASE_VERSION=1" ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    changelog = "https://github.com/dsimunic/elm-wrap/blob/${version}/CHANGELOG.md";
    description = "This utility is a comprehensive package management solution for Elm programming language packages and code. It wraps Elm compiler and intercepts its package management commands like install to augment them with support for custom package registries and policies.";
    homepage = "https://elm-wrap.dev/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ turbomack ];
    mainProgram = "wrap";
  };
}
