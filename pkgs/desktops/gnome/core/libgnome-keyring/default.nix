{ lib, stdenv, fetchurl, glib, dbus, libgcrypt, pkg-config, intltool, gobject-introspection, gnome
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgnome-keyring";
  version = "3.12.0";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnome-keyring/${lib.versions.majorMinor finalAttrs.version}/libgnome-keyring-${finalAttrs.version}.tar.xz";
    sha256 = "c4c178fbb05f72acc484d22ddb0568f7532c409b0a13e06513ff54b91e947783";
  };

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ glib gobject-introspection dbus libgcrypt ];
  nativeBuildInputs = [ pkg-config intltool ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "Framework for managing passwords and other secrets";
    homepage = "https://gitlab.gnome.org/Archive/libgnome-keyring";
    license = with lib.licenses; [ gpl2Plus lgpl2Plus ];
    pkgConfigModules = [ "gnome-keyring-1" ];
    platforms = lib.platforms.unix;
    maintainers = [];

    longDescription = ''
      gnome-keyring is a program that keeps password and other secrets for
      users. The library libgnome-keyring is used by applications to integrate
      with the gnome-keyring system.
    '';
  };
})
