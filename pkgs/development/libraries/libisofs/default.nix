{ lib, stdenv, fetchurl, acl, attr, zlib }:

stdenv.mkDerivation rec {
  pname = "libisofs";
  version = "1.5.4";

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-qqDtgKdQGXkxb1BbCwF/Kcug6lRjt1EUO60sNgIVqI4=";
  };

  buildInputs = [ attr zlib ];
  propagatedBuildInputs = [ acl ];

  meta = with lib; {
    homepage = "http://libburnia-project.org/";
    description = "A library to create an ISO-9660 filesystem with extensions like RockRidge or Joliet";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ abbradar vrthra ];
    platforms = with platforms; linux;
  };
}
