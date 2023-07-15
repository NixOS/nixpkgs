{ lib, stdenvNoCC, fetchzip }:

let
  fonts = {
    aegan     = { version = "13.00"; file = "Aegean.zip";       hash = "sha256-3HmCqCMZLN6zF1N/EirQOPnHKTGHoc4aHKoZxFYTB34="; description = "Aegean"; };
    aegyptus  = { version = "13.00"; file = "Aegyptus.zip";     hash = "sha256-SSAK707xhpsUTq8tSBcrzNGunCYad58amtCqAWuevnY="; description = "Egyptian Hieroglyphs, Coptic, Meroitic"; };
    akkadian  = { version = "13.00"; file = "Akkadian.zip";     hash = "sha256-wXiDYyfujAs6fklOCqXq7Ms7wP5RbPlpNVwkUy7CV4k="; description = "Sumero-Akkadian Cuneiform"; };
    assyrian  = { version = "13.00"; file = "Assyrian.zip";     hash = "sha256-CZj1sc89OexQ0INb7pbEu5GfE/w2E5JmhjT8cosoLSg="; description = "Neo-Assyrian in Unicode with OpenType"; };
    eemusic   = { version = "13.00"; file = "EEMusic.zip";      hash = "sha256-LxOcQOPEImw0wosxJotbOJRbe0qlK5dR+kazuhm99Kg="; description = "Byzantine Musical Notation in Unicode with OpenType"; };
    maya      = { version = "13.00"; file = "Maya%20Hieroglyphs.zip"; hash = "sha256-PAwF1lGqm6XVf4NQCA8AFLGU40N0Xsn5Q8x9ikHJDhY="; description = "Maya Hieroglyphs"; };
    symbola   = { version = "13.00"; file = "Symbola.zip";      hash = "sha256-TsHWmzkEyMa8JOZDyjvk7PDhm239oH/FNllizNFf398="; description = "Basic Latin, Greek, Cyrillic and many Symbol blocks of Unicode"; };
    textfonts = { version = "13.00"; file = "Textfonts.zip";    hash = "sha256-7S3NiiyDvyYoDrLPt2z3P9bEEFOEZACv2sIHG1Tn6yI="; description = "Aroania, Anaktoria, Alexander, Avdira and Asea"; };
    unidings  = { version = "13.00"; file = "Unidings.zip";     hash = "sha256-WUY+Ylphep6WuzqLQ3Owv+vK5Yuu/aAkn4GOFXL0uQY="; description = "Glyphs and Icons for blocks of The Unicode Standard"; };
  };

  mkpkg = pname: { version, file, hash, description }: stdenvNoCC.mkDerivation rec {
    inherit pname version;

    src = fetchzip {
      url = "https://dn-works.com/wp-content/uploads/2020/UFAS-Fonts/${file}";
      stripRoot = false;
      inherit hash;
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/{fonts/opentype,doc/${pname}}
      mv *.otf                -t "$out/share/fonts/opentype"
      mv *.{odt,ods,pdf,xlsx}       -t "$out/share/doc/${pname}"  || true  # install docs if any

      runHook postInstall
    '';

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
