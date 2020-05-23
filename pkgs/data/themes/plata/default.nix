{ stdenv, fetchFromGitLab, autoreconfHook, pkgconfig, parallel
, sassc, inkscape, libxml2, glib, gdk-pixbuf, librsvg, gtk-engine-murrine
, cinnamonSupport ? true
, gnomeFlashbackSupport ? true
, gnomeShellSupport ? true
, openboxSupport ? true
, xfceSupport ? true
, mateSupport ? true, gtk3, marco
, gtkNextSupport ? false
, plankSupport ? false
, steamSupport ? false
, telegramSupport ? false, zip
, tweetdeckSupport ? false
, selectionColor ? null # Primary color for 'selected-items' (Default: #3F51B5 = Indigo500)
, accentColor ? null # Secondary color for notifications and OSDs (Default: #7986CB = Indigo300)
, suggestionColor ? null # Secondary color for 'suggested' buttons (Default: #673AB7 = DPurple500)
, destructionColor ? null # Tertiary color for 'destructive' buttons (Default: #F44336 = Red500)
}:

stdenv.mkDerivation rec {
  pname = "plata-theme";
  version = "0.9.8";

  src = fetchFromGitLab {
    owner = "tista500";
    repo = "plata-theme";
    rev = version;
    sha256 = "1sqmydvx36f6r4snw22s2q4dvcyg30jd7kg7dibpzqn3njfkkfag";
  };

  preferLocalBuild = true;

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    parallel
    sassc
    inkscape
    libxml2
    glib.dev
  ]
  ++ stdenv.lib.optionals mateSupport [ gtk3 marco ]
  ++ stdenv.lib.optional telegramSupport zip;

  buildInputs = [
    gdk-pixbuf
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
      (enableFeature mateSupport "mate")
      (enableFeature gtkNextSupport "gtk_next")
      (enableFeature plankSupport "plank")
      (enableFeature steamSupport "airforsteam")
      (enableFeature telegramSupport "telegram")
      (enableFeature tweetdeckSupport "tweetdeck")
    ]
    ++ (withOptional selectionColor "selection_color")
    ++ (withOptional accentColor "accent_color")
    ++ (withOptional suggestionColor "suggestion_color")
    ++ (withOptional destructionColor "destruction_color");

  postInstall = ''
    for dest in $out/share/gtksourceview-{3.0,4}/styles; do
      mkdir -p $dest
      cp $out/share/themes/Plata-{Noir,Lumine}/gtksourceview/*.xml $dest
    done
  '';

  meta = with stdenv.lib; {
    description = "A GTK theme based on Material Design Refresh";
    homepage = "https://gitlab.com/tista500/plata-theme";
    license = with licenses; [ gpl2 cc-by-sa-40 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.tadfisher ];
  };
}
