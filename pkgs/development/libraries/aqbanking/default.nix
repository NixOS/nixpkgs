{ stdenv, fetchurl, gmp, gwenhywfar, libtool, libxml2, libxslt
, pkgconfig, xmlsec, zlib
}:

stdenv.mkDerivation rec {
  name = "aqbanking-5.5.1";

  src = fetchurl {
    url = "http://www2.aquamaniac.de/sites/download/download.php?package=03&release=118&file=01&dummy=${name}.tar.gz";
    name = "${name}.tar.gz";
    sha256 = "1pxd5xv2xls1hyizr1vbknzgb66babhlp72777rcxq46gp91g3r3";
  };

  buildInputs = [ gmp gwenhywfar libtool libxml2 libxslt xmlsec zlib ];

  nativeBuildInputs = [ pkgconfig ];

  configureFlags = "--with-gwen-dir=${gwenhywfar}";

  meta = with stdenv.lib; {
    description = "An interface to banking tasks, file formats and country information";
    homepage = "http://www2.aquamaniac.de/sites/download/packages.php?package=03&showall=1";
    hydraPlatforms = [];
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ goibhniu urkud ];
    platforms = platforms.linux;
  };
}
