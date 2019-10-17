{ stdenv, fetchurl, gmp, gwenhywfar, libtool, libxml2, libxslt
, pkgconfig, gettext, xmlsec, zlib
}:

stdenv.mkDerivation rec {
  pname = "aqbanking";
  version = "6.1.1";

  src = fetchurl {
    url = https://www.aquamaniac.de/rdm/attachments/download/266/aqbanking-6.1.1.tar.gz;
    sha256 = "0f33v4ridfn3cd0nj2c183yl8pdb4w2fa30bswrm6mc2sy6a4wpl";
  };

  /*
  fix error: 

  CMake Error at /nix/store/gxpscib9m9f3by77m367fmpiavcai380-gwenhywfar-4.99.22rc6/lib/cmake/gwenhywfar-4.99/gwenhywfar-config.cmake:7 (message):
  File or directory
  /nix/store/gxpscib9m9f3by77m367fmpiavcai380-gwenhywfar-4.99.22rc6/include/aqbanking6
  referenced by variable AQBANKING_INCLUDE_DIRS does not exist !
  Call Stack (most recent call first):
  /nix/store/f8wm9s005c4kkc6mhhlb6dv8lqk8vrhf-aqbanking-5.99.40beta/lib/cmake/aqbanking-5.99/aqbanking-config.cmake:24 (set_and_check)
  CMakeLists.txt:237 (find_package)

  when building kmymoney.
  i think it's because includedir is overwitten by gwenhywfar's .cmake file.
  */
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
    homepage = https://www.aquamaniac.de/rdm/projects/aqbanking;
    hydraPlatforms = [];
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
