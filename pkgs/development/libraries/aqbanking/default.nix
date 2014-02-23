{ stdenv, fetchurl, gmp, gwenhywfar, libtool, libxml2, libxslt
, pkgconfig, xmlsec, zlib
}:

stdenv.mkDerivation rec {
  name = "aqbanking-5.4.0beta";

  src = fetchurl {
    url = "http://www2.aquamaniac.de/sites/download/download.php?package=03&release=112&file=01&dummy=aqbanking-5.4.0beta.tar.gz";
    name = "${name}.tar.gz";
    sha256 = "0yd588sw9grc2c0bfyx8h39mr30pa1zxrcbv31p6pz6szilk2agh";
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
