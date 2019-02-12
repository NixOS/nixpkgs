{ stdenv, fetchurl, mkfontscale, mkfontdir }:

stdenv.mkDerivation rec {
  name = "unifont-${version}";
  version = "11.0.03";

  ttf = fetchurl {
    url = "mirror://gnu/unifont/${name}/${name}.ttf";
    sha256 = "1fqlf3kczh1y7vhpcdcs1i9043idg5x9jisfqfd99sikvcbw7w75";
  };

  pcf = fetchurl {
    url = "mirror://gnu/unifont/${name}/${name}.pcf.gz";
    sha256 = "0wqcmvkqdww60hqh245whzh4mx3frrx2712lay826f9h5s4ywz6g";
  };

  nativeBuildInputs = [ mkfontscale mkfontdir ];

  phases = "installPhase";

  installPhase =
    ''
      mkdir -p $out/share/fonts $out/share/fonts/truetype
      cp -v ${pcf} $out/share/fonts/unifont.pcf.gz
      cp -v ${ttf} $out/share/fonts/truetype/unifont.ttf
      cd $out/share/fonts
      mkfontdir
      mkfontscale
    '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "006jbla4zfwccyy84sm4ck869sq5az5s5cfkcmdgj7ah3rz4d7dn";

  meta = with stdenv.lib; {
    description = "Unicode font for Base Multilingual Plane";
    homepage = http://unifoundry.com/unifont.html;

    # Basically GPL2+ with font exception.
    license = http://unifoundry.com/LICENSE.txt;
    maintainers = [ maintainers.rycee maintainers.vrthra ];
    platforms = platforms.all;
  };
}
