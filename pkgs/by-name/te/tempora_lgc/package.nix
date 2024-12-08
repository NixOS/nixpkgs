{lib, stdenv, fetchurl}:
let
  srcs = [
    (fetchurl {
      url = "http://www.ttfotf.com/download-font/tempora-lgc-unicode-bold-italic.otf";
      sha256 = "1yfbi62j6gjmzglxz29m6x6lxqpxghcqjjh916qn8in74ba5v0gq";
    })
    (fetchurl {
      url = "http://www.ttfotf.com/download-font/tempora-lgc-unicode-bold.otf";
      sha256 = "0bfbl1h9h1022km2rg1zwl9lpabhnwdsvzdp0bwmf0wbm62550cp";
    })
    (fetchurl {
      url = "http://www.ttfotf.com/download-font/tempora-lgc-unicode-italic.otf";
      sha256 = "10m9j4bvr6c4zp691wxm4hvzhph2zlfsxk1nmbsb9vn1i6vfgz04";
    })
    (fetchurl {
      url = "http://www.ttfotf.com/download-font/tempora-lgc-unicode.otf";
      sha256 = "0iwa8wyydcpjss6d1jy4jibqxpvzph4vmaxwwmndpsqy1fz64y9i";
    })
  ];
  nativeBuildInputs = [
  ];
in
stdenv.mkDerivation {
  name = "tempora-lgc";
  inherit nativeBuildInputs;
  inherit srcs;
  installPhase = ''
    mkdir -p "$out/share/fonts/opentype/public"
    cp ${toString srcs} "$out/share/fonts/opentype/public"
  '';
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1kwj31cjgdirqvh6bxs4fnvvr1ppaz6z8w40kvhkivgs69jglmzw";

  meta = {
    description = "Tempora font";
    license = lib.licenses.gpl2 ;
    maintainers = [lib.maintainers.raskin];
  };
}
