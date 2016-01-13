{ stdenv, fetchgit, makeWrapper, autoreconfHook, pkgconfig, libuuid, clutter_1_24,
  glib, gobjectIntrospection, gnome3_18, libpulseaudio, libwnck, vala_0_28,
  intltool, libxml2, gettext, librsvg, gdk_pixbuf, polkit }:

let
  gnome3 = gnome3_18;
in
stdenv.mkDerivation rec {
  name = "budgie-desktop-${version}";
  version = "10.2.2";

  src = fetchgit {
    url = https://github.com/solus-project/budgie-desktop.git;
    rev = "refs/tags/v${version}";
    sha256 = "0q1x8x9pw1zfw3qpiq5h8k15snpim67qisa5x7mx17bvxrxzrh46";
    deepClone = true;
  };

  buildInputs = [ autoreconfHook makeWrapper pkgconfig clutter_1_24 libuuid glib
                  gobjectIntrospection gnome3.gtk gnome3.defaultIconTheme
                  gnome3.libpeas gnome3.mutter gnome3.gnome_desktop
                  gnome3.gnome-menus gnome3.gnome_session librsvg gdk_pixbuf
                  libpulseaudio libwnck vala_0_28 intltool libxml2
                  gettext polkit ];

  preConfigure = ''
    substituteInPlace autogen.sh \
      --replace '`which autoreconf`' '"x"' \
      --replace 'DEF_OPTS="--prefix=/usr --sysconfdir=/etc"' 'DEF_OPTS="--prefix=$out --sysconfdir=$out/etc"'
    substituteInPlace session/budgie-desktop.in \
      --replace 'exec gnome-session' 'exec ${gnome3.gnome_session}/bin/gnome-session'
  '';

  # fatal error: gio/gdesktopappinfo.h: No such file or directory
  NIX_CFLAGS_COMPILE = "-I${glib}/include/gio-unix-2.0";

  configureScript = "./autogen.sh";

  makeFlags = "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0 INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0";

  preFixup = ''
    wrapProgram "$out/bin/budgie-panel" \
      --prefix GI_TYPELIB_PATH : "$out/lib/girepository-1.0:$GI_TYPELIB_PATH" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "$out/share:$XDG_ICON_DIRS:${gnome3.gnome_themes_standard}/share:$GSETTINGS_SCHEMAS_PATH"
    wrapProgram "$out/bin/budgie-wm" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH"
    wrapProgram "$out/bin/budgie-desktop" \
      --prefix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://solus-project.com;
    description = "Flagship desktop of the Solus Project";
    license = [ licenses.gpl3 licenses.lgpl3 ];
    maintainers = with maintainers; [ jgillich ];
  };

}
