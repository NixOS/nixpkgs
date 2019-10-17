{ stdenv, fetchurl, gmp, gwenhywfar, libtool, libxml2, libxslt
, pkgconfig, gettext, xmlsec, zlib, fetchpatch, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "aqbanking";
  version = "5.7.8";

  src = fetchurl {
    url = https://www.aquamaniac.de/rdm/attachments/download/27/aqbanking-5.7.8.tar.gz;
    sha256 = "0s67mysskbiw1h1p0np4ph4351r7wq3nc873vylam7lsqi66xy0n";
  };

  # patch bug with newer automake
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=906583
  patches = [
    (fetchpatch {
      name = "fix_aqhbci_testlib_dependencies.patch";
      url = "https://bugs.debian.org/cgi-bin/bugreport.cgi?att=1;bug=906583;filename=fix_aqhbci_testlib_dependencies.patch;msg=10";
      sha256 = "1vz219cih6mz1s7fhh16snslqlxyn11yjb4q516l52yvc4324yis";
    })
  ];

  postAutoreconf = ''
    sed -i -e '/^aqbanking_plugindir=/ {
      c aqbanking_plugindir="\''${libdir}/gwenhywfar/plugins"
    }' configure
  '';

  buildInputs = [ gmp gwenhywfar libtool libxml2 libxslt xmlsec zlib ];

  nativeBuildInputs = [ pkgconfig gettext autoreconfHook ];

  configureFlags = [ "--with-gwen-dir=${gwenhywfar}" ];

  meta = with stdenv.lib; {
    description = "An interface to banking tasks, file formats and country information";
    homepage = http://www2.aquamaniac.de/sites/download/packages.php?package=03&showall=1;
    hydraPlatforms = [];
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
