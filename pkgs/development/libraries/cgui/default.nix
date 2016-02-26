{ stdenv, fetchurl, texinfo, allegro, perl }:

stdenv.mkDerivation rec {
  name = "cgui-${version}";
  version="2.0.3";

  src = fetchurl {
    url = "mirror://sourceforge/project/cgui/${version}/${name}.tar.gz";
    sha256 = "00kk4xaw68m44awy8zq4g5plx372swwccvzshn68a0a8f3f2wi4x";
  };

  buildInputs = [ texinfo allegro perl ];

  configurePhase = ''
    sh fix.sh unix
  '';

  hardeningDisable = [ "format" ];

  makeFlags = [ "SYSTEM_DIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "A multiplatform basic GUI library";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
