{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libfilezilla-${version}";
  version = "0.10.1";

  src = fetchurl {
    url = "http://download.filezilla-project.org/libfilezilla/${name}.tar.bz2";
    sha256 = "1yi9db0hpxh3giyjhkbz7ajmf95qw27xdvh3xvw208zri5k575x0";
  };

  meta = with stdenv.lib; {
    homepage = https://lib.filezilla-project.org/;
    description = "A modern C++ library, offering some basic functionality to build high-performing, platform-independent programs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
