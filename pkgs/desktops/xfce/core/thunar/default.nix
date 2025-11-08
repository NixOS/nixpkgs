{
  stdenv,
  mkXfceDerivation,
  lib,
  docbook_xsl,
  exo,
  gdk-pixbuf,
  gtk3,
  libexif,
  libgudev,
  libnotify,
  libX11,
  libxfce4ui,
  libxfce4util,
  libxslt,
  pcre2,
  xfce4-panel,
  xfconf,
  withIntrospection ? false,
  gobject-introspection,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "thunar";
  version = "4.20.6";

  sha256 = "sha256-Ll1mJEkkxYGASWQ2z7GRiubNjggqeHXzgGSXQK+10qs=";

  nativeBuildInputs = [
    docbook_xsl
    libxslt
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
  ];

  buildInputs = [
    exo
    gdk-pixbuf
    gtk3
    libX11
    libexif # image properties page
    libgudev
    libnotify
    libxfce4ui
    libxfce4util
    pcre2 # search & replace renamer
    xfce4-panel # trash panel applet plugin
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

  preFixup = ''
    gappsWrapperArgs+=(
      # https://github.com/NixOS/nixpkgs/issues/329688
      --prefix PATH : ${lib.makeBinPath [ exo ]}
    )
  '';

  meta = with lib; {
    description = "Xfce file manager";
    mainProgram = "thunar";
    teams = [ teams.xfce ];
  };
}
