{ stdenv, fetchurl, libxml2, gnutls, libxslt, pkgconfig, libgcrypt, libtool
, openssl, makeWrapper }:

let
  version = "1.2.23";
in
stdenv.mkDerivation rec {
  name = "xmlsec-${version}";

  src = fetchurl {
    url = "http://www.aleksey.com/xmlsec/download/xmlsec1-${version}.tar.gz";
    sha256 = "17qfw5crkqn4v6xbkjxrjvcccfc00dy053892wrwv54qdk8n7m21";
  };

  buildInputs = [ makeWrapper libxml2 gnutls libxslt pkgconfig libgcrypt libtool openssl ];
  enableParallelBuilding = true;
  doCheck = true;

  # otherwise libxmlsec1-gnutls.so won't find libgcrypt.so, after #909
  NIX_LDFLAGS = [ "-lgcrypt" ];

  postFixup = ''
    wrapProgram "$out/bin/xmlsec1" --prefix LD_LIBRARY_PATH ":" "$out/lib"
  '';

  meta = {
    homepage = http://www.aleksey.com/xmlsec;
    description = "XML Security Library in C based on libxml2";
    license = stdenv.lib.licenses.mit;
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
