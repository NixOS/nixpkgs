{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  runCommand,
  web-ext,
}:

buildNpmPackage rec {
  pname = "web-ext";
  version = "8.5.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "web-ext";
    rev = version;
    hash = "sha256-RT/K/fYMys1RAvnusAMuHtfZ7gndYf3FPuHBYCklBpw=";
  };

  npmDepsHash = "sha256-O8DmeT0wRNpuPU1K6kH97D9+mxOxCchAUrvOVPq4VPc=";

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
