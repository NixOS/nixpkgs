{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libfilezilla-${version}";
  version = "0.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/filezilla/libfilezilla/${version}/${name}.tar.bz2";
    sha256 = "73c3ada6f9c5649abd93e6a3e7ecc6682d4f43248660b5506918eab76a7b901b";
  };

  meta = with stdenv.lib; {
    homepage = https://lib.filezilla-project.org/;
    description = "A modern C++ library, offering some basic functionality to build high-performing, platform-independent programs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
