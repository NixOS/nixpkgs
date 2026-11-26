{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
}:

let
  fonts = {
    aegan = {
      pattern = "Aegean*";
      description = "Aegean";
    };
    aegyptus = {
      pattern = "Aegyptus*";
      description = "Egyptian Hieroglyphs, Coptic, Meroitic";
    };
    akkadian = {
      pattern = "Akkadian*";
      description = "Sumero-Akkadian Cuneiform";
    };
    assyrian = {
      pattern = "Assyrian*";
      description = "Neo-Assyrian in Unicode";
    };
    eemusic = {
      pattern = "Musica*";
      description = "Byzantine Musical Notation in Unicode with OpenType";
    };
    maya = {
      pattern = "Maya*";
      description = "Maya Hieroglyphs";
    };
    symbola = {
      pattern = "Symbola*";
      description = "Basic Latin, Greek, Cyrillic and many Symbol blocks of Unicode";
    };
    textfonts = {
      pattern = "Aroania* Anaktoria* Alexander* Avdira* Asea*";
      description = "Aroania, Anaktoria, Alexander, Avdira and Asea";
    };
    unidings = {
      pattern = "Unidings*";
      description = "Glyphs and Icons for blocks of The Unicode Standard";
    };
  };

  mkpkg =
    pname:
    {
      pattern,
      description,
    }:
    stdenvNoCC.mkDerivation (finalAttrs: {
      inherit pname;
      version = "2.60";
      src = fetchurl {
        # Launchpad is used to provide a more reliable download than internet archive.
        url = "https://launchpad.net/ubuntu/+archive/primary/+files/ttf-ancient-fonts_${finalAttrs.version}.orig.tar.xz";
        hash = "sha256-B3z/EUPwd/A4ZMC/aBz6+alKmR3bLVINqs/x+Sz2pUs=";
      };

      # Remove all files except selected
      patchPhase = ''
        mkdir keep
        cp ${pattern} keep
        find . -type f -delete -maxdepth 1
        ls keep
      '';

      nativeBuildInputs = [ installFonts ];

      meta = {
        inherit description;
        # see https://metadata.ftp-master.debian.org/changelogs//main/t/ttf-ancient-fonts/ttf-ancient-fonts_2.60-5_copyright
        license = lib.licenses.free;
        homepage = "https://web.archive.org/web/20221006174450/https://dn-works.com/ufas/";
      };
    });
in
lib.mapAttrs mkpkg fonts
