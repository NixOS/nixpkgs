{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libfilezilla-${version}";
  version = "0.11.0";

  src = fetchurl {
    url = "http://download.filezilla-project.org/libfilezilla/${name}.tar.bz2";
    sha256 = "1l4yhw269dyarqb2spqhycxzzyfn8pj4qh9vfycdw1c93hj6fx6c";
  };

  meta = with stdenv.lib; {
    homepage = https://lib.filezilla-project.org/;
    description = "A modern C++ library, offering some basic functionality to build high-performing, platform-independent programs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
