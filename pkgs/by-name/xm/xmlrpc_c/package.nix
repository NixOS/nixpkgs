{
  lib,
  stdenv,
  fetchurl,
  fetchDebianPatch,
  pkg-config,
  curl,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "xmlrpc-c";
  version = "1.60.05";

  src = fetchurl {
    url = "mirror://sourceforge/xmlrpc-c/xmlrpc-c-${version}.tgz";
    hash = "sha256-Z9hgBiRZ6ieEwHtNeRMxnZU5+nKfU0N46OQciRjyrfY=";
  };

  patches = [
    (fetchDebianPatch {
      inherit pname version;
      debianRevision = "1";
      patch = "fix-gcc15-build.patch";
      hash = "sha256-VcjXzzruDBuDarqhgNDHOtLxz2vlBrUAylILfMEGPmA=";
    })
  ];

  postPatch = ''
    rm -rf lib/expat
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    curl
    libxml2
  ];

  configureFlags = [
    "--enable-libxml2-backend"
  ];

  # Build and install the "xmlrpc" tool (like the Debian package)
  postInstall = ''
    (cd tools/xmlrpc && make && make install)
  '';

  enableParallelBuilding = true;

  # ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=implicit-function-declaration";

  meta = {
    description = "Lightweight RPC library based on XML and HTTP";
    homepage = "https://xmlrpc-c.sourceforge.net/";
    # <xmlrpc-c>/doc/COPYING also lists "ABYSS Web Server License" and "Python 1.5.2 License"
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.bjornfor ];
  };
}
