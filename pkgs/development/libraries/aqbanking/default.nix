{ stdenv, fetchurl, gwenhywfar, pkgconfig, gmp, zlib }:

stdenv.mkDerivation rec {
  name = "aqbanking-5.0.21";

  src = fetchurl {
    url = "http://www2.aquamaniac.de/sites/download/download.php?package=03&release=91&file=01&dummy=aqbanking-5.0.21.tar.gz";
    name = "${name}.tar.gz";
    sha256 = "1xvzg640fswkrjrkrqzj0j9lnij7kcpnyvzd7nsg1by40wxwgp52";
  };

  buildInputs = [ gwenhywfar gmp zlib ];

  nativeBuildInputs = [ pkgconfig ];

  configureFlags = "--with-gwen-dir=${gwenhywfar}";

  meta = {
    maintainers = [ stdenv.lib.maintainers.urkud ];
    # Tries to install gwenhywfar plugin, thus `make install` fails
    hydraPlatforms = [];
  };
}
