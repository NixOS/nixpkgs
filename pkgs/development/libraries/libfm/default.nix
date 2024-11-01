{ lib
, stdenv
, fetchurl
, glib
, intltool
, menu-cache
, pango
, pkg-config
, vala
, extraOnly ? false
, withGtk3 ? false, gtk2, gtk3
}:

let
    gtk = if withGtk3 then gtk3 else gtk2;
    inherit (lib) optional optionalString;
in
stdenv.mkDerivation rec {
  pname = if extraOnly
          then "libfm-extra"
          else "libfm";
  version = "1.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/pcmanfm/libfm-${version}.tar.xz";
    sha256 = "sha256-pQQmMDBM+OXYz/nVZca9VG8ii0jJYBU+02ajTofK0eU=";
  };

  nativeBuildInputs = [ vala pkg-config intltool ];
  buildInputs = [ glib gtk pango ]
                ++ optional (!extraOnly) menu-cache;

  configureFlags = [ "--sysconfdir=/etc" ]
                   ++ optional extraOnly "--with-extra-only"
                   ++ optional withGtk3 "--with-gtk=3";

  installFlags = [ "sysconfdir=${placeholder "out"}/etc" ];

  # libfm-extra is pulled in by menu-cache and thus leads to a collision for libfm
  postInstall = optionalString (!extraOnly) ''
     rm $out/lib/libfm-extra.so $out/lib/libfm-extra.so.* $out/lib/libfm-extra.la $out/lib/pkgconfig/libfm-extra.pc
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://blog.lxde.org/category/pcmanfm/";
    license = licenses.lgpl21Plus;
    description = "Glib-based library for file management";
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
