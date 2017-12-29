{ stdenv, fetchurl, acl, attr, zlib }:

stdenv.mkDerivation rec {
  name = "libisofs-${version}";
  version = "1.4.6";

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${name}.tar.gz";
    sha256 = "02m5g6lbmmkh2xc5xzq5zaf3ma6v31gls66aj886b3cq9qw0paql";
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
