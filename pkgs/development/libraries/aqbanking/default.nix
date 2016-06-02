{ stdenv, fetchurl, gmp, gwenhywfar, libtool, libxml2, libxslt
, pkgconfig, xmlsec, zlib
}:

stdenv.mkDerivation rec {
  name = "aqbanking-${version}";
  version = "5.6.10";

  src = let
    releaseNum = 206; # Change this on update
    qstring = "package=03&release=${toString releaseNum}&file=01";
    mkURLs = map (base: "${base}/sites/download/download.php?${qstring}");
  in fetchurl {
    name = "${name}.tar.gz";
    urls = mkURLs [ "http://www.aquamaniac.de" "http://www2.aquamaniac.de" ];
    sha256 = "1x0isvpk43rq2zlyyb9p0kgjmqv7yq07vgkiprw3f5sjkykvxw6d";
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
