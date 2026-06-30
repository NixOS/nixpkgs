{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "elementary-redacted-script";
  version = "5.1.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "fonts";
    tag = finalAttrs.version;
    hash = "sha256-YiE7yaH0ZrF1/Cp+3bcJYm2cExQjFcat6JLMJPjhops=";
  };

  dontBuild = true;

  nativeBuildInputs = [ installFonts ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Font for concealing text";
    homepage = "https://github.com/elementary/fonts";
    license = lib.licenses.ofl;
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.unix;
  };
})
