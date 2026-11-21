{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_26,
  testers,
}:
let
  version = "7.2.0";
  src = fetchFromGitHub {
    owner = "sindresorhus";
    repo = "trash-cli";
    rev = "v${version}";
    hash = "sha256-ZYxTcD1Bwcu0YmKllX9HMbhVpHR/zm2nwwcuwR/J8iw=";
  };
in
buildNpmPackage (finalAttrs: {
  inherit version src;

  __structuredAttrs = true;

  pname = "trash-cli-nodejs";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmFlags = [ "--ignore-scripts" ];

  npmDepsHash = "sha256-dVtxouuSQUk0wCy6V/1zwTYT8kYAnkZsRRCKLilsI2w=";

  nodejs = nodejs_26;

  dontNpmPrune = true;
  dontNpmBuild = true;

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "trash --version";
      version = finalAttrs.version;
    };
  };

  meta = {
    description = "Move files and folders to the trash. Works on macOS (10.12+), Linux, and Windows (8+). The sindresorhus/trash-cli version";
    homepage = "https://github.com/sindresorhus/trash-cli";
    license = lib.licenses.mit;
    mainProgram = "trash";
    maintainers = with lib.maintainers; [ adoyle ];
    platforms = lib.platforms.unix;
  };
})
