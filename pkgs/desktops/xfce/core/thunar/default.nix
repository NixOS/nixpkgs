{ mkXfceDerivation
, lib
, docbook_xsl
, exo
, gdk-pixbuf
, gtk3
, libgudev
, libnotify
, libX11
, libxfce4ui
, libxfce4util
, libxslt
, xfconf
, gobject-introspection
, gvfs
, makeWrapper
, symlinkJoin
, thunarPlugins ? []
}:

let unwrapped = mkXfceDerivation {
  category = "xfce";
  pname = "thunar";
  version = "1.8.14";

  sha256 = "1ph9bcqfm2nccliagl8zdl1dizh62qnr8m5hacri3cs2jhc0jjpy";

  nativeBuildInputs = [
    docbook_xsl
    gobject-introspection
    libxslt
  ];

  buildInputs = [
    exo
    gdk-pixbuf
    gtk3
    gvfs
    libX11
    libgudev
    libnotify
    libxfce4ui
    libxfce4util
    xfconf
  ];

  patches = [
    ./thunarx_plugins_directory.patch
  ];

  # the desktop file … is in an insecure location»
  # which pops up when invoking desktop files that are
  # symlinks to the /nix/store
  #
  # this error was added by this commit:
  # https://github.com/xfce-mirror/thunar/commit/1ec8ff89ec5a3314fcd6a57f1475654ddecc9875
  postPatch = ''
    sed -i -e 's|thunar_dialogs_show_insecure_program (parent, _(".*"), file, exec)|1|' thunar/thunar-file.c
  '';

  meta = {
    description = "Xfce file manager";
  };
};

in if thunarPlugins == [] then unwrapped
  else import ./wrapper.nix {
    inherit makeWrapper symlinkJoin thunarPlugins lib;
    thunar = unwrapped;
  }
