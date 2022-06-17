{ fetchzip, lib }:

let
  fonts = {
    aegan     = { version = "13.00"; file = "Aegean.zip";       sha256 = "sha256-1DnbfL6bKn8Upht/ZYfKIp9kuDHq7y9E+jkt2Yhr38A="; description = "Aegean"; };
    aegyptus  = { version = "13.00"; file = "Aegyptus.zip";     sha256 = "sha256-tObgHlhaquq6Akn/HdYKNfnKHHJP42yAT7lIn5qdCzY="; description = "Egyptian Hieroglyphs, Coptic, Meroitic"; };
    akkadian  = { version = "13.00"; file = "Akkadian.zip";     sha256 = "sha256-iHiXfxMS9FIlrRgT23MfxzCqYJMQrKuKYDShrqB74vU="; description = "Sumero-Akkadian Cuneiform"; };
    assyrian  = { version = "13.00"; file = "Assyrian.zip";     sha256 = "sha256-YjTQjv1Vybr14Sn9pUdbGYVf4ZIjGT+cpB1qCIg1NNQ="; description = "Neo-Assyrian in Unicode with OpenType"; };
    eemusic   = { version = "13.00"; file = "EEMusic.zip";      sha256 = "sha256-PaYBJOV+dmRV1ehY7TwDNL9dz1jPo58I3N8lWX1Vmy8="; description = "Byzantine Musical Notation in Unicode with OpenType"; };
    maya      = { version = "13.00"; file = "Maya%20Hieroglyphs.zip"; sha256 = "sha256-9uqGo4hweV1ydI+pEp76IqmHslWvxr87rTvziQs35bQ="; description = "Maya Hieroglyphs"; };
    symbola   = { version = "13.00"; file = "Symbola.zip";      sha256 = "sha256-C9HmforXr/Hqopb3go+bzqRFcWPv+0rz0JZsXc3mcxw="; description = "Basic Latin, Greek, Cyrillic and many Symbol blocks of Unicode"; };
    textfonts = { version = "13.00"; file = "Textfonts.zip";    sha256 = "sha256-1bDi5mwrT2I8gx6QdhnWjXATFdNAU9nt77BiFIci6C8="; description = "Aroania, Anaktoria, Alexander, Avdira and Asea"; };
    unidings  = { version = "13.00"; file = "Unidings.zip";     sha256 = "sha256-6lSkDb603XIrBGy4fZhY7xYDd3x0qA0PRQOlQ9Roig0="; description = "Glyphs and Icons for blocks of The Unicode Standard"; };
  };

  mkpkg = name_: {version, file, sha256, description}: fetchzip rec {
    name = "${name_}-${version}";
    url = "https://dn-works.com/wp-content/uploads/2020/UFAS-Fonts/${file}";
    stripRoot = false;
    postFetch = ''
      mkdir -p $out/share/{fonts/opentype,doc/${name_}}
      mv $out/*.otf                -t "$out/share/fonts/opentype"
      mv $out/*.{odt,ods,pdf,xlsx}       -t "$out/share/doc/${name_}"  || true  # install docs if any
      find $out -type d -empty -delete
      shopt -s extglob dotglob
      rm -rf $out/!(share)
      shopt -u extglob dotglob
    '';
    inherit sha256;

    meta = {
      inherit description;
      # see https://dn-works.com/wp-content/uploads/2020/UFAS-Docs/License.pdf
      # quite draconian: non-commercial, no modifications,
      # no redistribution, "a single instantiation and no
      # network installation"
      license = lib.licenses.unfree;
      homepage = "https://dn-works.com/ufas/";
    };
  };
in
  lib.mapAttrs mkpkg fonts
