{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  pkg-config,
  xalanc,
  xercesc,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xml-security-c";
  version = "3.0.0";

  src = fetchgit {
    url = "https://git.shibboleth.net/git/cpp-xml-security";
    rev = finalAttrs.version;
    hash = "sha256-D60JtD4p9ERh6sowvwBHtE9XWVm3D8saooagDvA6ZtQ=";
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

  buildInputs = [
    xalanc
    xercesc
    openssl
  ];

  meta = {
    homepage = "https://shibboleth.atlassian.net/wiki/spaces/DEV/pages/3726671873/Santuario";
    description = "C++ Implementation of W3C security standards for XML";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.jagajaga ];
  };
})
