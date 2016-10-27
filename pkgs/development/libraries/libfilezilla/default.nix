{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libfilezilla-${version}";
  version = "0.7.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/filezilla/libfilezilla/${version}/${name}.tar.bz2";
    sha256 = "1lyxlras357p17vbwfhwny69izjx74xncaxpyk1n4d2jbsvjspfr";
  };

  meta = with stdenv.lib; {
    homepage = https://lib.filezilla-project.org/;
    description = "A modern C++ library, offering some basic functionality to build high-performing, platform-independent programs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
