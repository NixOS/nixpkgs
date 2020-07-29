{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "cascadia-code";
  version = "2007.01";

  src = fetchzip {
    url = "https://github.com/microsoft/cascadia-code/releases/download/v${version}/CascadiaCode-${version}.zip";
    sha256 = "0jqggqjqck0nkq301r217hv9k5xzcy6vqc4fqgdmh2d9divbja5m";
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
