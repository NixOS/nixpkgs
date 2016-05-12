{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libfilezilla-${version}";
  version = "0.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/filezilla/libfilezilla/${version}/${name}.tar.bz2";
    sha256 = "1ydpk6i5vjd78i0531cxlkjvlmvvrsfyc7hv7wx81ws3rkp5hnsq";
  };

  meta = with stdenv.lib; {
    homepage = https://lib.filezilla-project.org/;
    description = "A modern C++ library, offering some basic functionality to build high-performing, platform-independent programs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
