{ stdenv, fetchFromGitLab, autoreconfHook, pkgconfig, parallel, zip
, sassc, inkscape, libxml2, gnome2, gdk_pixbuf, librsvg, gtk-engine-murrine
, cinnamonSupport ? true
, gnomeFlashbackSupport ? true
, gnomeShellSupport ? true
, openboxSupport ? true
, xfceSupport ? true
, gtkNextSupport ? false
, plankSupport ? false
, telegramSupport ? false
, tweetdeckSupport ? false
, selectionColor ? null # Primary color for 'selected-items' (Default: #3F51B5 = Indigo500)
, accentColor ? null # Secondary color for notifications and OSDs (Default: #7986CB = Indigo300)
, suggestionColor ? null # Secondary color for 'suggested' buttons (Default: #673AB7 = DPurple500)
, destructionColor ? null # Tertiary color for 'destructive' buttons (Default: #F44336 = Red500)
}:

stdenv.mkDerivation rec {
  pname = "plata-theme";
  version = "0.8.1";

  src = fetchFromGitLab {
    owner = "tista500";
    repo = "plata-theme";
    rev = version;
    sha256 = "0nq1c12ldaz9750dcb1vz0ff10s4171pjsd21sih1sz89z64q2hy";
  };

  preferLocalBuild = true;

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    parallel
    sassc
    inkscape
    libxml2
    gnome2.glib.dev
  ]
  ++ (stdenv.lib.optional (telegramSupport != null) zip);

  buildInputs = [
    gdk_pixbuf
    librsvg
  ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postPatch = "patchShebangs .";

  configureFlags =
    let
      inherit (stdenv.lib) enableFeature optional;
      withOptional = value: feat: optional (value != null) "--with-${feat}=${value}";
    in [
      "--enable-parallel"
      (enableFeature cinnamonSupport "cinnamon")
      (enableFeature gnomeFlashbackSupport "flashback")
      (enableFeature gnomeShellSupport "gnome")
      (enableFeature openboxSupport "openbox")
      (enableFeature xfceSupport "xfce")
      (enableFeature gtkNextSupport "gtk_next")
      (enableFeature plankSupport "plank")
      (enableFeature telegramSupport "telegram")
      (enableFeature tweetdeckSupport "tweetdeck")
    ]
    ++ (withOptional selectionColor "selection_color")
    ++ (withOptional accentColor "accent_color")
    ++ (withOptional suggestionColor "suggestion_color")
    ++ (withOptional destructionColor "destruction_color");

  meta = with stdenv.lib; {
    description = "A Gtk+ theme based on Material Design Refresh";
    homepage = https://gitlab.com/tista500/plata-theme;
    license = with licenses; [ gpl2 cc-by-sa-40 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.tadfisher ];
  };
}
