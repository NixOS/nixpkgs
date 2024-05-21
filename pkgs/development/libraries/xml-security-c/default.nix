{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xalanc,
  xercesc,
  openssl,
  darwin,
}:

let
  inherit (darwin.apple_sdk.frameworks) CoreFoundation CoreServices SystemConfiguration;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xml-security-c";
  version = "2.0.4";

  src = fetchurl {
    url = "mirror://apache/santuario/c-library/xml-security-c-${finalAttrs.version}.tar.gz";
    hash = "sha256-p42mcg9sK6FBANJCYTHg0z6sWi26XMEb3QSXS364kAM=";
  };

  configureFlags = [
    "--with-openssl"
    "--with-xerces"
    "--with-xalan"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      xalanc
      xercesc
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      CoreFoundation
      CoreServices
      SystemConfiguration
    ];

  meta = {
    homepage = "https://santuario.apache.org/";
    description = "C++ Implementation of W3C security standards for XML";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.jagajaga ];
  };
})
