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
, makeWrapper
, symlinkJoin
, thunarPlugins ? []
}:

let unwrapped = mkXfceDerivation {
  category = "xfce";
  pname = "thunar";
  version = "4.16.8";

  sha256 = "1r7qkd6l0mgf97m1xnnizm7fkvl4a52r3hsds5z68y6myvb78p18";

  nativeBuildInputs = [
    docbook_xsl
    gobject-introspection
    libxslt
  ];

  buildInputs = [
    exo
    gdk-pixbuf
    gtk3
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
