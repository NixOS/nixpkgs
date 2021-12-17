{ fetchzip, lib }:

let
  fonts = {
    aegan     = { version = "13.00"; file = "Aegean.zip";       sha256 = "1w4ks341jw12p6zi1fy1hb3kqiqv61yn8i2hr9ybng9n8xdw03li"; description = "Aegean"; };
    aegyptus  = { version = "13.00"; file = "Aegyptus.zip";     sha256 = "16j8rj3mr2cddag7laxvzpm5w3yk467fwzsk60nq8pnh6ab1v05y"; description = "Egyptian Hieroglyphs, Coptic, Meroitic"; };
    akkadian  = { version = "13.00"; file = "Akkadian.zip";     sha256 = "1f2v9cjk307c5lw0si9hwjcll5wb9nwwy5im0y16kvpgwh2ccshc"; description = "Sumero-Akkadian Cuneiform"; };
    assyrian  = { version = "13.00"; file = "Assyrian.zip";     sha256 = "18nx6ayfk3ba6wg1rp37r9fll5ajrwq2mp5w2l3y1q1kk92frkid"; description = "Neo-Assyrian in Unicode with OpenType"; };
    eemusic   = { version = "13.00"; file = "EEMusic.zip";      sha256 = "1kk5rd3wd7y13z9bqcg1k9idbwad4l3hfmi3lbfk4y1w895vgxk2"; description = "Byzantine Musical Notation in Unicode with OpenType"; };
    maya      = { version = "13.00"; file = "Maya%20Hieroglyphs.zip"; sha256 = "0fzzrlkd4m2dj2phg97nz782w0afmw0f0ykdvlwyp29j1ak7yyp1"; description = "Maya Hieroglyphs"; };
    symbola   = { version = "13.00"; file = "Symbola.zip";      sha256 = "04pxh5agvlkyg8mvv2szwshnmzi3n0m7va4xsyq401zbsa147rmi"; description = "Basic Latin, Greek, Cyrillic and many Symbol blocks of Unicode"; };
    textfonts = { version = "13.00"; file = "Textfonts.zip";    sha256 = "1xp8qlfpvcf5n96zgm07zij3ndlzvqjlii8gx9sbj5aa56rxkdgb"; description = "Aroania, Anaktoria, Alexander, Avdira and Asea"; };
    unidings  = { version = "13.00"; file = "Unidings.zip";     sha256 = "0cvnxblk9wsr8mxm5lrdpdm456vi7lln7qh53b67npg4baf0as63"; description = "Glyphs and Icons for blocks of The Unicode Standard"; };
  };

  mkpkg = name_: {version, file, sha256, description}: fetchzip rec {
    name = "${name_}-${version}";
    url = "https://dn-works.com/wp-content/uploads/2020/UFAS-Fonts/${file}";
    postFetch = ''
      mkdir -p $out/share/{fonts,doc}
      unzip -j $downloadedFile \*.otf                -d $out/share/fonts/opentype
      unzip -j $downloadedFile \*.odt \*.pdf \*.xlsx -d "$out/share/doc/${name}"  || true  # unpack docs if any
      rmdir "$out/share/doc/${name}" $out/share/doc                               || true  # remove dirs if empty
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
