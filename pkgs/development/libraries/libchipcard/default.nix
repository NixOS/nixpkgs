{ stdenv, fetchurl, pkgconfig, gwenhywfar, pcsclite, zlib }:

stdenv.mkDerivation rec {
  name = "libchipcard-${version}";
  version = "5.0.4";

  src = let
    releaseNum = 200; # Change this on update
    qstring = "package=02&release=${toString releaseNum}&file=01";
    mkURLs = map (base: "${base}/sites/download/download.php?${qstring}");
  in fetchurl {
    name = "${name}.tar.gz";
    urls = mkURLs [ "http://www.aquamaniac.de" "http://www2.aquamaniac.de" ];
    sha256 = "0fj2h39ll4kiv28ch8qgzdbdbnzs8gl812qnm660bw89rynpjnnj";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gwenhywfar pcsclite zlib ];

  makeFlags = [ "crypttokenplugindir=$(out)/lib/gwenhywfar/plugins/ct" ];

  configureFlags = [ "--with-gwen-dir=${gwenhywfar}" ];

  meta = with stdenv.lib; {
    description = "Library for access to chipcards";
    homepage = "http://www2.aquamaniac.de/sites/download/packages.php?package=02&showall=1";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ aszlig ];
    platforms = platforms.linux;
  };
}
