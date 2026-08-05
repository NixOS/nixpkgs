{
  lib,
  stdenv,
  fetchFromCodeberg,
  autoreconfHook,
  pkg-config,
  xalanc,
  xercesc,
  openssl,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xml-security-c";
  version = "3.0.0";

  src = fetchFromCodeberg {
    owner = "Shibboleth";
    repo = "cpp-xml-security";
    tag = finalAttrs.version;
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

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://shibboleth.atlassian.net/wiki/spaces/DEV/pages/3726671873/Santuario";
    description = "C++ Implementation of W3C security standards for XML";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ drawbu ];
  };
})
