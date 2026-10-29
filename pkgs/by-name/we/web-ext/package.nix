{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  runCommand,
  web-ext,
}:

buildNpmPackage (finalAttrs: {
  pname = "web-ext";
  version = "10.8.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "web-ext";
    rev = finalAttrs.version;
    hash = "sha256-GtBl7LNg/f2vSLsVW8/eyvmktyCunt/xq/AIk69XOmw=";
  };

  npmDepsHash = "sha256-q6F7W8BUAdiagPNiwrZjj48WALuZLItd5TEV6OOCj4s=";

  npmBuildFlags = [ "--production" ];

  passthru.tests.help = runCommand "${finalAttrs.pname}-tests" { } ''
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
})
