{ stdenv, fetchurl, pkgconfig, gwenhywfar, pcsclite, zlib }:

stdenv.mkDerivation rec {
  name = "libchipcard-${version}";
  version = "5.0.4";

  src = let
    inherit ((import ./sources.nix).libchipcard) sha256 releaseId;
    qstring = "package=02&release=${releaseId}&file=01";
    mkURLs = map (base: "${base}/sites/download/download.php?${qstring}");
  in fetchurl {
    name = "${name}.tar.gz";
    urls = mkURLs [ "http://www.aquamaniac.de" "http://www2.aquamaniac.de" ];
    inherit sha256;
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
