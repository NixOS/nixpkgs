# Originally packaged for ArchLinux.
#
# https://aur.archlinux.org/packages/ttf-montserrat/

{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "montserrat-${version}";
  version = "1.0";

  src = fetchurl {
    url = "http://marvid.fr/~eeva/mirror/Montserrat.tar.gz";
    sha256 = "12yn651kxi5fcbpdxhapg5fpri291mgcfc1kx7ymg53nrl11nj3x";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/montserrat
    cp *.ttf $out/share/fonts/montserrat
  '';

  meta = with stdenv.lib; {
    description = "A geometric sans serif font with extended latin support (Regular, Alternates, Subrayada)";
    homepage    = "http://www.fontspace.com/julieta-ulanovsky/montserrat";
    license     = licenses.ofl;
    platforms   = platforms.all;
    maintainers = with maintainers; [ scolobb ];
  };
}
