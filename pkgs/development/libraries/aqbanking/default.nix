{ stdenv, fetchurl, gmp, gwenhywfar, libtool, libxml2, libxslt
, pkgconfig, gettext, xmlsec, zlib
}:

stdenv.mkDerivation rec {
  name = "aqbanking-${version}";
  version = "5.6.10";

  src = let
    inherit ((import ./sources.nix).aqbanking) sha256 releaseId;
    qstring = "package=03&release=${releaseId}&file=01";
    mkURLs = map (base: "${base}/sites/download/download.php?${qstring}");
  in fetchurl {
    name = "${name}.tar.gz";
    urls = mkURLs [ "http://www.aquamaniac.de" "http://www2.aquamaniac.de" ];
    inherit sha256;
  };

  postPatch = ''
    sed -i -e '/^aqbanking_plugindir=/ {
      c aqbanking_plugindir="\''${libdir}/gwenhywfar/plugins"
    }' configure
  '';

  buildInputs = [ gmp gwenhywfar libtool libxml2 libxslt xmlsec zlib ];

  nativeBuildInputs = [ pkgconfig gettext ];

  configureFlags = [ "--with-gwen-dir=${gwenhywfar}" ];

  meta = with stdenv.lib; {
    description = "An interface to banking tasks, file formats and country information";
    homepage = "http://www2.aquamaniac.de/sites/download/packages.php?package=03&showall=1";
    hydraPlatforms = [];
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
