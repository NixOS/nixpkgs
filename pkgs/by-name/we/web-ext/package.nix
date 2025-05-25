{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  runCommand,
  web-ext,
}:

buildNpmPackage rec {
  pname = "web-ext";
  version = "8.6.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "web-ext";
    rev = version;
    hash = "sha256-y+aaAsAW1e+k5dnkYbq6JyRlKiC9wdXvyykUiKfQXis=";
  };

  npmDepsHash = "sha256-5YLTb8nwmHgl29ZO7UVh0IGD/Pl4lxWoDH9o8H/Cp/I=";

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
