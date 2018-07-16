{ stdenv, fetchurl, libxml2, gnutls, libxslt, pkgconfig, libgcrypt, libtool
, openssl, nss, makeWrapper }:

let
  version = "1.2.26";
in
stdenv.mkDerivation rec {
  name = "xmlsec-${version}";

  src = fetchurl {
    url = "https://www.aleksey.com/xmlsec/download/xmlsec1-${version}.tar.gz";
    sha256 = "0l1dk344rn3j2vnj13daz72xd8j1msvzhg82n2il5ji0qz4pd0ld";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ makeWrapper pkgconfig ];

  buildInputs = [ libxml2 gnutls libxslt libgcrypt libtool openssl nss ];

  enableParallelBuilding = true;
  doCheck = true;

  # enable deprecated soap headers required by lasso
  # https://dev.entrouvert.org/issues/18771
  configureFlags = [ "--enable-soap" ];

  # otherwise libxmlsec1-gnutls.so won't find libgcrypt.so, after #909
  NIX_LDFLAGS = [ "-lgcrypt" ];

  postInstall = ''
    moveToOutput "bin/xmlsec1-config" "$dev"
    moveToOutput "lib/xmlsec1Conf.sh" "$dev"
  '';

  postFixup = ''
    wrapProgram "$out/bin/xmlsec1" --prefix LD_LIBRARY_PATH ":" "$out/lib"
  '';

  meta = {
    homepage = http://www.aleksey.com/xmlsec;
    downloadPage = https://www.aleksey.com/xmlsec/download.html;
    description = "XML Security Library in C based on libxml2";
    license = stdenv.lib.licenses.mit;
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    updateWalker = true;
  };
}
