{ stdenv, fetchurl, acl, attr, zlib }:

stdenv.mkDerivation rec {
  name = "libisofs-${version}";
  version = "1.4.4";

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${name}.tar.gz";
    sha256 = "1zdx56k847c80ds5yf40hh0a26lkqrc0v11r589dqlm6xvzg0614";
  };

  buildInputs = [ attr zlib ];
  propagatedBuildInputs = [ acl ];

  meta = with stdenv.lib; {
    homepage = http://libburnia-project.org/;
    description = "A library to create an ISO-9660 filesystem with extensions like RockRidge or Joliet";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ abbradar vrthra ];
    platforms = with platforms; linux;
  };
}
