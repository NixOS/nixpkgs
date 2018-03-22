{ stdenv, fetchurl, glib, dbus_libs, libgcrypt, pkgconfig, intltool, gobjectIntrospection, gnome3 }:

let
  pname = "libgnome-keyring";
  version = "3.12.0";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "c4c178fbb05f72acc484d22ddb0568f7532c409b0a13e06513ff54b91e947783";
  };

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ glib gobjectIntrospection dbus_libs libgcrypt ];
  nativeBuildInputs = [ pkgconfig intltool ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = {
    description = "Framework for managing passwords and other secrets";
    homepage = https://wiki.gnome.org/Projects/GnomeKeyring;
    license = with stdenv.lib.licenses; [ gpl2Plus lgpl2Plus ];
    inherit (glib.meta) platforms maintainers;

    longDescription = ''
      gnome-keyring is a program that keeps password and other secrets for
      users. The library libgnome-keyring is used by applications to integrate
      with the gnome-keyring system.
    '';
  };
}
