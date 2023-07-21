{ lib, stdenv, fetchurl, acl, attr, libiconv, zlib }:

stdenv.mkDerivation rec {
  pname = "libisofs";
  version = "1.5.6.pl01";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${pname}-${version}.tar.gz";
    hash = "sha256-rB/TONZBdEyh+xVnkXGIt5vIwlBoMt1WiF/smGVrnyU=";
  };

  buildInputs = lib.optionals stdenv.isLinux [
    acl
    attr
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
  ] ++ [
    zlib
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://libburnia-project.org/";
    description = "A library to create an ISO-9660 filesystem with extensions like RockRidge or Joliet";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ abbradar vrthra ];
    platforms = with platforms; unix;
  };
}
