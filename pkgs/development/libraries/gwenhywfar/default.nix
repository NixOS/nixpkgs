{ stdenv, fetchurl, gnutls, gtk, libgcrypt, pkgconfig, qt4 }:

stdenv.mkDerivation rec {
  name = "gwenhywfar-${version}";

  version = "4.15.3";

  src = let
    releaseNum = 201; # Change this on update
    qstring = "package=01&release=${toString releaseNum}&file=01";
    mkURLs = map (base: "${base}/sites/download/download.php?${qstring}");
  in fetchurl {
    name = "${name}.tar.gz";
    urls = mkURLs [ "http://www.aquamaniac.de" "http://www2.aquamaniac.de" ];
    sha256 = "0fp67s932x66xfljb26zbrn8ambbc5y5c3hllr6l284nr63qf3ka";
  };

  propagatedBuildInputs = [ gnutls libgcrypt ];

  buildInputs = [ gtk qt4 ];

  nativeBuildInputs = [ pkgconfig ];

  QTDIR = qt4;

  meta = with stdenv.lib; {
    description = "OS abstraction functions used by aqbanking and related tools";
    homepage = "http://www2.aquamaniac.de/sites/download/packages.php?package=01&showall=1";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
