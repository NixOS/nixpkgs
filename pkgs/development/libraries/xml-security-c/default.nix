{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
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

  src = fetchgit {
    url = "https://git.shibboleth.net/git/cpp-xml-security";
    rev = finalAttrs.version;
    hash = "sha256-60A6LqUUGmoZMmIvhuZWjrZl6utp7WLhPe738oNd/AA=";
  };

  configureFlags = [
    "--with-openssl"
    "--with-xerces"
    "--with-xalan"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs =
    [
      xalanc
      xercesc
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      CoreFoundation
      CoreServices
      SystemConfiguration
    ];

  meta = {
    homepage = "https://shibboleth.atlassian.net/wiki/spaces/DEV/pages/3726671873/Santuario";
    description = "C++ Implementation of W3C security standards for XML";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.jagajaga ];
  };
})
