{ stdenv, fetchsvn, autoconf, automake, libtool, nettle, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libfilezilla-${version}";
  version = "0.15.1";

  src = fetchsvn {
    url = "https://svn.filezilla-project.org/svn/libfilezilla/tags/${version}";
    sha256 = "0nhi75rr0hzql7533i78bkvnrjgh0dv5g5vfwfidjkli2xk9i867";
  };

  buildInputs = [ autoconf automake libtool nettle pkgconfig ];

  preConfigure = ''
    autoreconf -i
    '';

  meta = with stdenv.lib; {
    homepage = https://lib.filezilla-project.org/;
    description = "A modern C++ library, offering some basic functionality to build high-performing, platform-independent programs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
