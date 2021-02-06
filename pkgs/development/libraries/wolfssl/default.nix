{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "wolfssl";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "wolfSSL";
    repo = "wolfssl";
    rev = "v${version}-stable";
    sha256 = "0hk3bnzznxj047gwxdxw2v3w6jqq47996m7g72iwj6c2ai9g6h4m";
  };

  # almost same as Debian but for now using --enable-all instead of --enable-distro to ensure options.h gets installed
  configureFlags = [ "--enable-all --enable-pkcs11 --enable-tls13 --enable-base64encode" ];

  outputs = [ "out" "dev" "doc" "lib" ];

  nativeBuildInputs = [ autoreconfHook ];

  postPatch = ''
     # fix recursive cycle:
     # build flags (including location of header files) are exposed in the
     # public API of wolfssl, causing lib to depend on dev
     substituteInPlace configure.ac \
       --replace '#define LIBWOLFSSL_CONFIGURE_ARGS \"$ac_configure_args\"' ' '
     substituteInPlace configure.ac \
       --replace '#define LIBWOLFSSL_GLOBAL_CFLAGS \"$CPPFLAGS $AM_CPPFLAGS $CFLAGS $AM_CFLAGS\"' ' '
  '';


  postInstall = ''
     # fix recursive cycle:
     # wolfssl-config points to dev, dev propagates bin
     moveToOutput bin/wolfssl-config "$dev"
     # moveToOutput also removes "$out" so recreate it
     mkdir -p "$out"
  '';

  meta = with lib; {
    description = "A small, fast, portable implementation of TLS/SSL for embedded devices";
    homepage    = "https://www.wolfssl.com/";
    platforms   = platforms.all;
    license = lib.licenses.gpl2;
    maintainers = with maintainers; [ mcmtroffaes ];
  };
}
