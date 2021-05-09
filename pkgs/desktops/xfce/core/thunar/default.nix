{ mkXfceDerivation
, lib
, fetchpatch
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
  version = "4.16.6";

  sha256 = "12zqwazsqdmghy4h2c4fwxha069l07d46i512395y22h7n6655rn";

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
    #  Dont execute files, passed via command line due to security risks, remove >=4.17.3
    (fetchpatch {
      url = "https://gitlab.xfce.org/xfce/thunar/-/commit/9165a61f95e43cc0b5abf9b98eee2818a0191e0b.patch";
      sha256 = "1yi26xyyr6c0xsmrpvlk72v4szlmqhwz83q719afbq5yr3ycyd50";
    })
    # Regression: Activating Desktop Icon does not Use Default Application, remove >=4.17.3
    (fetchpatch {
      url = "https://gitlab.xfce.org/xfce/thunar/-/commit/3b54d9d7dbd7fd16235e2141c43a7f18718f5664.patch";
      sha256 = "02xzpirgaq37fzsazzhnb80bqw1r4h71yhdy35pp50vs8wfb9al1";
    })
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
