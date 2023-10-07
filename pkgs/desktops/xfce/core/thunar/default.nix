{ mkXfceDerivation
, fetchpatch
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
, pcre
, xfconf
, gobject-introspection
, makeWrapper
, symlinkJoin
, thunarPlugins ? []
}:

let unwrapped = mkXfceDerivation {
  category = "xfce";
  pname = "thunar";
  version = "4.18.7";

  sha256 = "sha256-pxIblhC40X0wdE6+uvmV5ypp4sOZtzn/evcS33PlNpU=";

  patches = [
    # Fix log spam with new GLib
    # https://gitlab.xfce.org/xfce/thunar/-/issues/1204
    (fetchpatch {
      url = "https://gitlab.xfce.org/xfce/thunar/-/commit/2f06fcdbedbc59d9f90ccd3df07fce417cea391d.patch";
      sha256 = "sha256-nvYakT4GJkQYmubgZF8GJIA/m7+6ZPbmD0HSgMcCh10=";
    })
  ];

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
    pcre
    xfconf
  ];

  configureFlags = [ "--with-custom-thunarx-dirs-enabled" ];

  # the desktop file … is in an insecure location»
  # which pops up when invoking desktop files that are
  # symlinks to the /nix/store
  #
  # this error was added by this commit:
  # https://github.com/xfce-mirror/thunar/commit/1ec8ff89ec5a3314fcd6a57f1475654ddecc9875
  postPatch = ''
    sed -i -e 's|thunar_dialogs_show_insecure_program (parent, _(".*"), file, exec)|1|' thunar/thunar-file.c
  '';

  meta = with lib; {
    description = "Xfce file manager";
    mainProgram = "thunar";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
};

in if thunarPlugins == [] then unwrapped
  else import ./wrapper.nix {
    inherit makeWrapper symlinkJoin thunarPlugins lib;
    thunar = unwrapped;
  }
