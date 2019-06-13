{ stdenv, fetchurl, fetchpatch, pkgconfig, bison, flex, intltool, gtk, libical, dbus-glib, tzdata
, libnotify, popt, xfce, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  name = "${p_name}-${ver_maj}.${ver_min}";
  p_name  = "orage";
  ver_maj = "4.12";
  ver_min = "1";

  src = fetchurl {
    url = "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0qlhvnl2m33vfxqlbkic2nmfpwyd4mq230jzhs48cg78392amy9w";
  };

  patches = [
    # Fix build with libical 3.0
    (fetchpatch {
      name = "fix-libical3.patch";
      url = https://git.archlinux.org/svntogit/packages.git/plain/trunk/libical3.patch?h=packages/orage&id=7b1b06c42dda034d538977b9f3550b28e370057f;
      sha256 = "1l8s106mcidmbx2p8c2pi8v9ngbv2x3fsgv36j8qk8wyd4qd1jbf";
    })
  ];

  postPatch = ''
    substituteInPlace src/parameters.c        --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
    substituteInPlace src/tz_zoneinfo_read.c  --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
    substituteInPlace tz_convert/tz_convert.c --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
  '';

  postConfigure = "rm -rf libical"; # ensure pkgs.libical is used instead of one included in the orage sources

  nativeBuildInputs = [ pkgconfig intltool bison flex ];

  buildInputs = [ gtk libical dbus-glib libnotify popt xfce.libxfce4util
    xfce.xfce4-panel ];

  meta = {
    homepage = https://www.xfce.org/projects/;
    description = "A simple calendar application with reminders";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
