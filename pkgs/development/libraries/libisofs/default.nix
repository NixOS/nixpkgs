{ stdenv, fetchurl, acl, attr, zlib }:

stdenv.mkDerivation rec {
  name = "libisofs-${version}";
  version = "1.4.2";

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${name}.tar.gz";
    sha256 = "1axk1ykv8ibrlrd2f3allidviimi4ya6k7wpvr6r4y1sc7mg7rym";
  };

  buildInputs = [ attr zlib ];
  propagatedBuildInputs = [ acl ];

  meta = with stdenv.lib; {
    homepage = http://libburnia-project.org/;
    description = "A library to create an ISO-9660 filesystem with extensions like RockRidge or Joliet";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ abbradar ];
  };
}
