{ stdenv, fetchurl, libxml2, gnutls, libxslt, pkgconfig, libgcrypt, libtool
# nss_3_53 is used instead of the latest due to a number of issues:
# https://github.com/lsh123/xmlsec/issues?q=is%3Aissue+is%3Aopen+nss
, openssl, nss_3_53, lib, runCommandCC, writeText }:

lib.fix (self:
let
  version = "1.2.31";
in
stdenv.mkDerivation {
  pname = "xmlsec";
  inherit version;

  src = fetchurl {
    url = "https://www.aleksey.com/xmlsec/download/xmlsec1-${version}.tar.gz";
    sha256 = "mxC8Uswx5PdhYuOXXlDbJrcatJxXHYELMRymJr5aCyY=";
  };

  patches = [
    ./lt_dladdsearchdir.patch
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ ./remove_bsd_base64_decode_flag.patch ];
  postPatch = ''
    substituteAllInPlace src/dl.c
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libxml2 gnutls libxslt libgcrypt libtool openssl nss_3_53 ];

  enableParallelBuilding = true;
  doCheck = true;
  checkInputs = [ nss_3_53.tools ];
  preCheck = ''
  substituteInPlace tests/testrun.sh \
    --replace 'timestamp=`date +%Y%m%d_%H%M%S`' 'timestamp=19700101_000000' \
    --replace 'TMPFOLDER=/tmp' '$(mktemp -d)'
  '';

  # enable deprecated soap headers required by lasso
  # https://dev.entrouvert.org/issues/18771
  configureFlags = [ "--enable-soap" ];

  # otherwise libxmlsec1-gnutls.so won't find libgcrypt.so, after #909
  NIX_LDFLAGS = "-lgcrypt";

  postInstall = ''
    moveToOutput "bin/xmlsec1-config" "$dev"
    moveToOutput "lib/xmlsec1Conf.sh" "$dev"
  '';

  passthru.tests.libxmlsec1-crypto = runCommandCC "libxmlsec1-crypto-test"
    {
      nativeBuildInputs = [ pkgconfig ];
      buildInputs = [ self libxml2 libxslt libtool ];
    } ''
    $CC $(pkg-config --cflags --libs xmlsec1) -o crypto-test ${writeText "crypto-test.c" ''
      #include <xmlsec/xmlsec.h>
      #include <xmlsec/crypto.h>

      int main(int argc, char **argv) {
        return xmlSecInit() ||
          xmlSecCryptoDLLoadLibrary(argc > 1 ? argv[1] : 0) ||
          xmlSecCryptoInit();
      }
    ''}

    for crypto in "" gcrypt gnutls nss openssl; do
      ./crypto-test $crypto
    done
    touch $out
  '';

  meta = {
    homepage = "http://www.aleksey.com/xmlsec";
    downloadPage = "https://www.aleksey.com/xmlsec/download.html";
    description = "XML Security Library in C based on libxml2";
    license = stdenv.lib.licenses.mit;
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    updateWalker = true;
  };
}
)
