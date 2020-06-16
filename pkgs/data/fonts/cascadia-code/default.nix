{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "cascadia-code";
  version = "2005.15";

  src = fetchzip {
    url = "https://github.com/microsoft/cascadia-code/releases/download/v${version}/CascadiaCode_${version}.zip";
    sha256 = "0wm8lqhgkz691w6ai6r45c7199p7bpr00rm8nz4ynafrb15fgm6v";
    stripRoot = false;
  };

  installPhase = ''
    install -Dm444 -t $out/share/fonts/truetype ttf/*.ttf
    install -Dm444 -t $out/share/fonts/opentype otf/*.otf
  '';

  meta = with stdenv.lib; {
    description = "Monospaced font that includes programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal";
    homepage = "https://github.com/microsoft/cascadia-code";
    license = licenses.ofl;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
