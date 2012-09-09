{ stdenv, fetchurl, tcl, openssl }:

stdenv.mkDerivation rec {
  name = "tcltls-${version}";
  version = "1.6";

  configureFlags = "--with-tcl=" + tcl + "/lib "
                 + "--with-tclinclude=" + tcl + "/include "
                 + "--with-ssl-dir=" + openssl;

  preConfigure = ''
    configureFlags="--exec_prefix=$prefix $configureFlags"
  '';

  src = fetchurl {
    url = "mirror://sourceforge/tls/tls${version}-src.tar.gz";
    sha256 = "adec50143a9ad634a671d24f7c7bbf2455487eb5f12d290f41797c32a98b93f3";
  };

  passthru = {
    libPrefix = "tls${version}";
  };

  buildInputs = [ tcl openssl ];

  meta = {
    homepage = "http://tls.sourceforge.net/";
    description = "An OpenSSL / RSA-bsafe Tcl extension";
    license = stdenv.lib.licenses.tcltk;
  };
}
