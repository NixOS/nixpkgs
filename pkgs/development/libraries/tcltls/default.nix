{ lib, fetchurl, tcl, openssl }:

tcl.mkTclDerivation rec {
  pname = "tcltls";
  version = "1.7.21";

  src = fetchurl {
    url = "https://core.tcl-lang.org/tcltls/uv/tcltls-${version}.tar.gz";
    sha256 = "0xf1rfsnn4k9j1bd2a1p8ir0xr4a3phgr9lcgbazh4084l2y8sl0";
  };

  buildInputs = [ openssl ];

  configureFlags = [
    "--with-ssl-dir=${openssl.dev}"
  ];

  meta = {
    homepage = "https://core.tcl-lang.org/tcltls/index";
    description = "An OpenSSL / RSA-bsafe Tcl extension";
    maintainers = [ lib.maintainers.agbrooks ];
    license = lib.licenses.tcltk;
    platforms = lib.platforms.unix;
  };
}
