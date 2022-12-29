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
  version = "4.18.1";

  sha256 = "sha256-n624TZGygFrOjkQ9fUVJUetRV8JDXYSg89tOHm4Va+M=";

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
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
};

in if thunarPlugins == [] then unwrapped
  else import ./wrapper.nix {
    inherit makeWrapper symlinkJoin thunarPlugins lib;
    thunar = unwrapped;
  }
