{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  gdk-pixbuf,
  gnome-themes-extra,
  gtk-engine-murrine,
  jdupes,
  librsvg,
  sassc,
  which,
  themeVariants ? [ ], # default: blue
  colorVariants ? [ ], # default: all
  tweaks ? [ ],
}:

let
  pname = "qogir-theme";

in
lib.checkListOfEnum "${pname}: theme variants" [ "default" "manjaro" "ubuntu" "all" ] themeVariants
  lib.checkListOfEnum
  "${pname}: color variants"
  [ "standard" "light" "dark" ]
  colorVariants
  lib.checkListOfEnum
  "${pname}: tweaks"
  [ "image" "square" "round" ]
  tweaks

  stdenv.mkDerivation
  rec {
    inherit pname;
    version = "2023-05-24";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = pname;
      rev = version;
      sha256 = "L19pbmJJFr1xi4ZTp0ocxmdMvWmtkK2zquOFfbV+P5Q=";
    };

    nativeBuildInputs = [
      jdupes
      sassc
      which
    ];

    buildInputs = [
      gdk-pixbuf # pixbuf engine for Gtk2
      gnome-themes-extra # adwaita engine for Gtk2
      librsvg # pixbuf loader for svg
    ];

    propagatedUserEnvPkgs = [
      gtk-engine-murrine # murrine engine for Gtk2
    ];

    postPatch = ''
      patchShebangs install.sh clean-old-theme.sh
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/themes

      name= HOME="$TMPDIR" ./install.sh \
        ${lib.optionalString (themeVariants != [ ]) "--theme " + builtins.toString themeVariants} \
        ${lib.optionalString (colorVariants != [ ]) "--color " + builtins.toString colorVariants} \
        ${lib.optionalString (tweaks != [ ]) "--tweaks " + builtins.toString tweaks} \
        --dest $out/share/themes

      mkdir -p $out/share/doc/${pname}
      cp -a src/firefox $out/share/doc/${pname}

      rm $out/share/themes/*/{AUTHORS,COPYING}

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    passthru.updateScript = gitUpdater { };

    meta = with lib; {
      description = "Flat Design theme for GTK based desktop environments";
      homepage = "https://github.com/vinceliuice/Qogir-theme";
      license = licenses.gpl3Only;
      platforms = platforms.unix;
      maintainers = [ maintainers.romildo ];
    };
  }
