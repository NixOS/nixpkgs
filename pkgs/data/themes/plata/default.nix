{ stdenv, fetchFromGitLab, autoreconfHook, pkgconfig, parallel
, sassc, inkscape, libxml2, gnome2, gdk_pixbuf, librsvg, gtk-engine-murrine
, cinnamonSupport ? true
, gnomeFlashbackSupport ? true
, gnomeShellSupport ? true
, mateSupport ? true
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
  name = "plata-theme-${version}";
  version = "0.7.6";

  src = fetchFromGitLab {
    owner = "tista500";
    repo = "plata-theme";
    rev = version;
    sha256 = "1jllsl2h3zdvlp3k2dy3h4jyccrzzymwbqz43jhnm6mxxabxzijg";
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
  ];

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
      (enableFeature mateSupport "mate")
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
