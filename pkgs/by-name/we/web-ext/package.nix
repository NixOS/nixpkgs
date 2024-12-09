{ lib
, buildNpmPackage
, fetchFromGitHub
, runCommand
, web-ext
}:

buildNpmPackage rec {
  pname = "web-ext";
  version = "8.3.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "web-ext";
    rev = version;
    hash = "sha256-Jlxfsyir1+vutfuHt6SxBkcn0PTtr9/cZzEGa6z6LU0=";
  };

  npmDepsHash = "sha256-MCK1bCWZpUk2Z/+ZWsY+iUCpz+n1UEcBqkAtiBtJl0k=";

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
