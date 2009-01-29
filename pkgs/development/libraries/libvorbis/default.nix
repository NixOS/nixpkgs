{stdenv, fetchurl, libogg}:

stdenv.mkDerivation {
  name = "libvorbis-1.2.0";
  src = fetchurl {
    url = http://downloads.xiph.org/releases/vorbis/libvorbis-1.2.0.tar.bz2;
    sha256 = "0nq62b8y2rhhgxxyiw6b4wchic61q5v649fdl8dd7090nxxcbx4y";
  };

  propagatedBuildInputs = [ libogg ];
}
