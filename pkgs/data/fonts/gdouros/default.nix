{ fetchzip, lib }:

let
  fonts = {
    aegan     = { version = "10.00"; file = "Aegean.zip";       sha256 = "0k47nhzw4vx771ch3xx8mf6xx5vx0hg0cif5jdlmdaz4h2c3rawz"; description = "Aegean"; };
    aegyptus  = { version =  "8.00"; file = "Aegyptus.zip";     sha256 = "13h2pi641k9vxgqi9l11mjya10ym9ln54wrkwxx6gxq63zy7y5mj"; description = "Egyptian Hieroglyphs, Coptic, Meroitic"; };
    akkadian  = { version =  "7.18"; file = "Akkadian.zip";     sha256 = "1bplcvszbdrk85kqipn9lzhr62647wjibz1p8crzjvsw6f9ymxy3"; description = "Sumero-Akkadian Cuneiform"; };
    assyrian  = { version =  "2.00"; file = "AssyrianFont.zip"; sha256 = "0vdvb24vsnmwzd6bw14akqg0hbvsk8avgnbwk9fkybn1f801475k"; description = "Neo-Assyrian in Unicode with OpenType"; };
    eemusic   = { version =  "2.00"; file = "EEMusic.zip";      sha256 = "1y9jf105a2b689m7hdjmhhr7z5j0qd2w6dmb3iic9bwaczlrjy7j"; description = "Byzantine Musical Notation in Unicode with OpenType"; };
    maya      = { version =  "4.18"; file = "Maya.zip";         sha256 = "08z2ch0z2c43fjfg5m4yp3l1dp0cbk7lv5i7wzsr3cr9kr59wpi9"; description = "Maya Hieroglyphs"; };
    symbola   = { version = "12.00"; file = "Symbola.zip";      sha256 = "1i3xra33xkj32vxs55xs2afrqyc822nk25669x78px5g5qd8gypm"; description = "Basic Latin, Greek, Cyrillic and many Symbol blocks of Unicode"; };
    textfonts = { version =  "9.00"; file = "Textfonts.zip";    sha256 = "0wzxz4j4fgk81b88d58715n1wvq2mqmpjpk4g5hi3vk77y2zxc4d"; description = "Aroania, Anaktoria, Alexander, Avdira and Asea"; };
    unidings  = { version =  "9.19"; file = "Unidings.zip";     sha256 = "1bybzgdqhmq75hb12n3pjrsdcpw1a6sgryx464s68jlq4zi44g78"; description = "Glyphs and Icons for blocks of The Unicode Standard"; };
  };

  mkpkg = name_: {version, file, sha256, description}: fetchzip rec {
    name = "${name_}-${version}";
    url = "http://users.teilar.gr/~g1951d/${file}";
    postFetch = ''
      mkdir -p $out/share/{fonts,doc}
      unzip -j $downloadedFile \*.ttf                 -d $out/share/fonts/truetype
      unzip -j $downloadedFile \*.docx \*.pdf \*.xlsx -d "$out/share/doc/${name}" || true  # unpack docs if any
      rmdir "$out/share/doc/${name}" $out/share/doc                               || true  # remove dirs if empty
    '';
    inherit sha256;

    meta = {
      inherit description;
      # In lieu of a license:
      # Fonts in this site are offered free for any use;
      # they may be installed, embedded, opened, edited, modified, regenerated, posted, packaged and redistributed.
      license = lib.licenses.free;
      homepage = http://users.teilar.gr/~g1951d/;
    };
  };
in
  lib.mapAttrs mkpkg fonts
