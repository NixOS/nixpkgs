{ stdenv, fetchurl, acl, attr, zlib }:

stdenv.mkDerivation rec {
  name = "libisofs-${version}";
  version = "1.4.8";

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${name}.tar.gz";
    sha256 = "0scvqb72qq24wcg814p1iw1dknldl21hr1hxsc1wy9vc6vgyk7fw";
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
