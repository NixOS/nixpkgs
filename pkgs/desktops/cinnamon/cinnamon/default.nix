{ atk, autoreconfHook, cacert, cinnamon-desktop, cinnamon-menus, cjs, dbus_glib, fetchFromGitHub, gdk_pixbuf, glib, gobjectIntrospection, gtk3, intltool, json-glib, libcroco, libsoup, libstartup_notification, libXtst, muffin, networkmanager, pkgconfig, polkit, stdenv }:

stdenv.mkDerivation rec {
  pname = "cinnamon";
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon";
    rev = "${version}";
    sha256 = "1lhqvj2jy4zq3kpv4m8nvxj6w5h61i3gb934fdi04scqwwyxsny7";
  };

  patches = [ ./disable-docs.patch ];

  buildInputs = [ atk cacert cinnamon-desktop cinnamon-menus cjs dbus_glib gdk_pixbuf glib gobjectIntrospection gtk3 intltool json-glib libcroco libsoup libstartup_notification libXtst muffin networkmanager pkgconfig polkit ];
  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = "--disable-static --with-ca-certificates=${cacert}/etc/ssl/certs/ca-bundle.crt";

  # Run intltoolize to create po/Makefile.in.in
  preConfigure = ''
    intltoolize
  '';

  postPatch = ''
    substituteInPlace src/Makefile.am \
      --replace "\$(libdir)/muffin" "${muffin}/lib/muffin"
  '';
}
