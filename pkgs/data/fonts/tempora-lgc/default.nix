{stdenv, fetchurl}:
let
  srcs = [
    (fetchurl {
      url = http://www.ttfotf.com/download-font/tempora-lgc-unicode-bold-italic.otf;
      sha256 = "1yfbi62j6gjmzglxz29m6x6lxqpxghcqjjh916qn8in74ba5v0gq";
    })
    (fetchurl {
      url = http://www.ttfotf.com/download-font/tempora-lgc-unicode-bold.otf;
      sha256 = "0bfbl1h9h1022km2rg1zwl9lpabhnwdsvzdp0bwmf0wbm62550cp";
    })
    (fetchurl {
      url = http://www.ttfotf.com/download-font/tempora-lgc-unicode-italic.otf;
      sha256 = "10m9j4bvr6c4zp691wxm4hvzhph2zlfsxk1nmbsb9vn1i6vfgz04";
    })
    (fetchurl {
      url = http://www.ttfotf.com/download-font/tempora-lgc-unicode.otf;
      sha256 = "0iwa8wyydcpjss6d1jy4jibqxpvzph4vmaxwwmndpsqy1fz64y9i";
    })
  ];
  buildInputs = [
  ];
in
stdenv.mkDerivation {
  name = "tempora-lgc";
  inherit buildInputs;
  inherit srcs;
  phases = "installPhase";
  installPhase = ''
    mkdir -p "$out/share/fonts/opentype/public"
    cp ${toString srcs} "$out/share/fonts/opentype/public"
  '';
  meta = {
    description = ''Tempora font'';
    license = stdenv.lib.licenses.gpl2 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
