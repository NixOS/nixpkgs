{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  runCommand,
  web-ext,
}:

buildNpmPackage rec {
  pname = "web-ext";
  version = "9.1.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "web-ext";
    rev = version;
    hash = "sha256-vt3Kj675ws9WBhI3cZM12R0iiAye2Rc5m9KIIsboGNA=";
  };

  npmDepsHash = "sha256-9H+y4F29+NwjfmoqCA+Bg/+ST/710Gp+IGa+z0a4I/k=";

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
