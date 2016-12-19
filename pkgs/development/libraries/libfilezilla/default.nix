{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libfilezilla-${version}";
  version = "0.9.0";

  src = fetchurl {
    url = "http://download.filezilla-project.org/libfilezilla/${name}.tar.bz2";
    sha256 = "0340v5xs48f28q2d16ldb9359dkzlhl4l449mgyv3qabnlz2pl21";
  };

  meta = with stdenv.lib; {
    homepage = https://lib.filezilla-project.org/;
    description = "A modern C++ library, offering some basic functionality to build high-performing, platform-independent programs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
