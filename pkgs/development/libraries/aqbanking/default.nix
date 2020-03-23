{ stdenv, fetchurl, gmp, gwenhywfar, libtool, libxml2, libxslt
, pkgconfig, gettext, xmlsec, zlib
}:

let
  inherit ((import ./sources.nix).aqbanking) sha256 releaseId version;
in stdenv.mkDerivation rec {
  pname = "aqbanking";
  inherit version;

  src = fetchurl {
    url = "https://www.aquamaniac.de/rdm/attachments/download/${releaseId}/${pname}-${version}.tar.gz";
    inherit sha256;
  };

  # Set the include dir explicitly, this fixes a build error when building
  # kmymoney because otherwise the includedir is overwritten by gwenhywfar's
  # cmake file
  postPatch = ''
    sed -i '/^set_and_check(AQBANKING_INCLUDE_DIRS "@aqbanking_headerdir@")/i set_and_check(includedir "@includedir@")' aqbanking-config.cmake.in
    sed -i -e '/^aqbanking_plugindir=/ {
      c aqbanking_plugindir="\''${libdir}/gwenhywfar/plugins"
    }' configure
  '';

  buildInputs = [ gmp gwenhywfar libtool libxml2 libxslt xmlsec zlib ];

  nativeBuildInputs = [ pkgconfig gettext ];

  meta = with stdenv.lib; {
    description = "An interface to banking tasks, file formats and country information";
    homepage = http://www2.aquamaniac.de/sites/download/packages.php?package=03&showall=1;
    hydraPlatforms = [];
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
