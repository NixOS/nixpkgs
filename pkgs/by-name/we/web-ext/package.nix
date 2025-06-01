{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  runCommand,
  web-ext,
}:

buildNpmPackage rec {
  pname = "web-ext";
  version = "8.7.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "web-ext";
    rev = version;
    hash = "sha256-k/S9YBU7D7FoXLK9aufBQfD4ZjCdlhGeDBnvfOk5H6Y=";
  };

  npmDepsHash = "sha256-sykNWATICiPz3naZyzl6+b0g0v0D1AsfGYT5bahTlBI=";

  npmBuildFlags = [ "--production" ];

  passthru.tests.help = runCommand "${pname}-tests" { } ''
    ${web-ext}/bin/web-ext --help
    touch $out
  '';

  meta = {
    description = "Command line tool to help build, run, and test web extensions";
    homepage = "https://github.com/mozilla/web-ext";
    license = lib.licenses.mpl20;
    mainProgram = "web-ext";
    maintainers = [ ];
  };
}
