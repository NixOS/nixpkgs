{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "urbanist";
  version = "1.330";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchzip {
    url = "https://github.com/coreyhu/Urbanist/releases/download/${finalAttrs.version}/Urbanist-fonts.zip";
    hash = "sha256-XkdiTq1OsZ3HrbPVHMht9JTQtqvp+txIPvJYYRffrmQ=";
  };

  sourceRoot = "source/Urbanist-fonts/fonts";

  nativeBuildInputs = [ installFonts ];
  dontInstallWebfonts = true;

  meta = {
    homepage = "https://github.com/coreyhu/Urbanist";
    description = "Low-contrast, geometric sans-serif inspired by Modernist design and typography";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ozozka ];
  };
})
