{ atk, autoreconfHook, cacert, cinnamon-desktop, cinnamon-menus, cjs, dbus_glib, fetchFromGitHub, gdk_pixbuf, glib, gobjectIntrospection, gtk3, intltool, json-glib, libcroco, libsoup, libstartup_notification, libXtst, muffin, networkmanager, pkgconfig, polkit, stdenv, wrapGAppsHook, libxml2 }:

stdenv.mkDerivation rec {
  pname = "cinnamon";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "0sv7nqd1l6c727qj30dcgdkvfh1wxpszpgmbdyh58ilmc8xklnqd";
  };

  patches = [ ./disable-docs.patch ];

  buildInputs = [ atk cacert cinnamon-desktop cinnamon-menus cjs dbus_glib gdk_pixbuf glib gobjectIntrospection gtk3 json-glib libcroco libsoup libstartup_notification libXtst muffin networkmanager pkgconfig polkit libxml2 ];
  nativeBuildInputs = [ autoreconfHook wrapGAppsHook intltool ];

  configureFlags = [ "--disable-static" "--with-ca-certificates=${cacert}/etc/ssl/certs/ca-bundle.crt" "--with-libxml=${libxml2.dev}/include/libxml2" ];

  # Run intltoolize to create po/Makefile.in.in
  preConfigure = ''
    intltoolize
  '';

  postPatch = ''
    substituteInPlace src/Makefile.am \
      --replace "\$(libdir)/muffin" "${muffin}/lib/muffin"
  '';
}
