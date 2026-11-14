{
  stdenv,
  fetchurl,
  libxml2,
  gnutls,
  libxslt,
  pkg-config,
  libtool,
  openssl,
  nss,
  lib,
  python3Packages,
  runCommandCC,
  writeText,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xmlsec";
  version = "1.3.12";

  __structuredAttrs = true;

  src = fetchurl {
    urls = [
      "https://www.aleksey.com/xmlsec/download/xmlsec1-${finalAttrs.version}.tar.gz"

      # for when the ${finalAttrs.version} gets older than the last two
      "https://www.aleksey.com/xmlsec/download/older-releases/xmlsec1-${finalAttrs.version}.tar.gz"
    ];
    hash = "sha256-JARRma8S2T/l/bu/fjhugj5IQgcelDLiuQrBCLiJqSM=";
  };

  patches = [
    ./lt_dladdsearchdir.patch
    ./remove_bsd_base64_decode_flag.patch
  ];

  postPatch = ''
    substituteInPlace src/dl.c --replace-fail "@out@" "$out"
  '';

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libxml2
    gnutls
    libtool
    openssl
    nss
  ];

  propagatedBuildInputs = [
    # required by xmlsec/transforms.h
    libxslt
  ];

  enableParallelBuilding = true;
  doCheck = true;
  nativeCheckInputs = [ nss.tools ];
  preCheck = ''
    export TMPFOLDER=$(mktemp -d)
    substituteInPlace tests/testrun.sh --replace 'timestamp=`date +%Y%m%d_%H%M%S`' 'timestamp=19700101_000000'
  '';

  # enable deprecated soap headers required by lasso
  # https://dev.entrouvert.org/issues/18771
  configureFlags = [ "--enable-soap" ];

  postInstall = ''
    moveToOutput "bin/xmlsec1-config" "$dev"
    moveToOutput "lib/xmlsec1Conf.sh" "$dev"
  '';

  passthru.tests = {
    python-xmlsec = python3Packages.xmlsec;
    libxmlsec1-crypto =
      runCommandCC "libxmlsec1-crypto-test"
        {
          nativeBuildInputs = [ pkg-config ];
          buildInputs = [
            finalAttrs.finalPackage
            libxml2
            libxslt
            libtool
          ];
        }
        ''
          $CC $(pkg-config --cflags --libs xmlsec1) -o crypto-test ${writeText "crypto-test.c" ''
            #include <xmlsec/xmlsec.h>
            #include <xmlsec/crypto.h>

            int main(int argc, char **argv) {
              return xmlSecInit() ||
                xmlSecCryptoDLLoadLibrary(argc > 1 ? argv[1] : 0) ||
                xmlSecCryptoInit();
            }
          ''}

          for crypto in "" gnutls nss openssl; do
            ./crypto-test $crypto
          done
          touch $out
        '';
  };

  meta = {
    description = "XML Security Library in C based on libxml2";
    homepage = "https://www.aleksey.com/xmlsec/";
    downloadPage = "https://www.aleksey.com/xmlsec/download.html";
    license = lib.licenses.mit;
    mainProgram = "xmlsec1";
    maintainers = [ ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
