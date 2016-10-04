{stdenv, fetchurl, unzip, lib }:
let
  fonts = {
    symbola = { version = "9.00"; file = "Symbola.zip"; sha256 = "0d9zrlvzh8inhr17p99banr0dmrvkwxbk3q7zhqqx2z4gf2yavc5";
                description = "Basic Latin, Greek, Cyrillic and many Symbol blocks of Unicode"; };
    aegyptus = { version = "6.00"; file = "Aegyptus.zip"; sha256 = "10mr54ja9b169fhqfkrw510jybghrpjx7a8a7m38k5v39ck8wz6v";
                 description = "Egyptian Hieroglyphs, Coptic, Meroitic"; };
    akkadian = { version = "7.13"; file = "Akkadian.zip"; sha256 = "1jd2fb6jnwpdwgkidsi2pnw0nk2cpya8k85299w591sqslfkxyij";
                 description = "Sumero-Akkadian Cuneiform"; };
    anatolian = { version = "5.02"; file = "Anatolian.zip"; sha256 = "0arm58sijzk0bqmfb70k1sjvq79wgw16hx3j2g4l8qz4sv05bp8l";
                  description = "Anatolian Hieroglyphs"; };
    maya = { version = "4.14"; file = "Maya.zip"; sha256 = "0l97racgncrhb96mfbsx8dr5n4j289iy0nnwhxf9b21ns58a9x4f";
             description = "Maya Hieroglyphs"; };
    unidings = { version = "8.00"; file = "Unidings.zip"; sha256 = "1i0z3mhgj4680188lqpmk7rx3yiz4l7yybb4wq6zk35j75l28irm";
                 description = "Glyphs and Icons for blocks of The Unicode Standard"; };
    musica = { version = "3.12"; file = "Musica.zip"; sha256 = "079vyb0mpxvlcf81d5pqh9dijkcvidfbcyvpbgjpmgzzrrj0q210";
               description = "Musical Notation"; };
    analecta = { version = "5.00"; file = "Analecta.zip"; sha256 = "0rphylnz42fqm1zpx5jx60k294kax3sid8r2hx3cbxfdf8fnpb1f";
                 description = "Coptic, Gothic, Deseret"; };
    # the following are also available from http://users.teilar.gr/~g1951d/
    # but not yet packaged:
    #  - Aroania
    #  - Anaktoria
    #  - Alexander
    #  - Avdira
    #  - Asea
    #  - Aegean
  };
  mkpkg = name_: {version, file, sha256, description}:
    stdenv.mkDerivation rec {
      name = "${name_}-${version}";

      src = fetchurl {
        url = "http://users.teilar.gr/~g1951d/${file}";
        inherit sha256;
      };

      buildInputs = [ unzip ];

      sourceRoot = ".";

      installPhase = ''
        mkdir -p $out/share/fonts/truetype
        cp -v *.ttf $out/share/fonts/truetype/

        mkdir -p "$out/doc/${name}"
        cp -v *.docx *.pdf *.xlsx "$out/doc/${name}/"
      '';

      meta = {
        inherit description;
        # In lieu of a license:
        # Fonts in this site are offered free for any use;
        # they may be installed, embedded, opened, edited, modified, regenerated, posted, packaged and redistributed.
        license = stdenv.lib.licenses.free;
        homepage = http://users.teilar.gr/~g1951d/;
        platforms = stdenv.lib.platforms.unix;
      };
    };

in
lib.mapAttrs mkpkg fonts
