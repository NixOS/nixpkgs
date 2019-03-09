{ stdenv, fetchurl, texinfo, allegro, perl, libX11 }:

stdenv.mkDerivation rec {
  name = "cgui-${version}";
  version="2.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/cgui/${version}/${name}.tar.gz";
    sha256 = "1pp1hvidpilq37skkmbgba4lvzi01rasy04y0cnas9ck0canv00s";
  };

  buildInputs = [ texinfo allegro perl libX11 ];

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
