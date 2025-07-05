{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  runCommand,
  web-ext,
}:

buildNpmPackage rec {
  pname = "web-ext";
  version = "8.8.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "web-ext";
    rev = version;
    hash = "sha256-119LxYhTqzobcwJZ0DSawNUIVMWxWSQp/XtkGEK2L7k=";
  };

  npmDepsHash = "sha256-Na0caulpTMMIvsXC04+x8GUWDCyX6f6vVNmlnN694BE=";

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
