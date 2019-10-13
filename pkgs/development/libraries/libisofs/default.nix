{ stdenv, fetchurl, acl, attr, zlib }:

stdenv.mkDerivation rec {
  pname = "libisofs";
  version = "1.5.0";

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${pname}-${version}.tar.gz";
    sha256 = "001l3akf3wb6msl9man776w560iqyvsbwwzs7d7y7msx13irspys";
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
