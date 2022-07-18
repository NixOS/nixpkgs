{ lib
, stdenvNoCC
, fetchFromGitHub
, gitUpdater
, gnome-themes-extra
, gtk-engine-murrine
, jdupes
, sassc
, themeVariants ? [] # default: blue
, colorVariants ? [] # default: all
, sizeVariants ? [] # default: standard
, tweaks ? []
, wallpapers ? false
, withGrub ? false
, grubScreens ? [] # default: 1080p
}:

let
  pname = "graphite-gtk-theme";

in
lib.checkListOfEnum "${pname}: theme variants" [ "default" "purple" "pink" "red" "orange" "yellow" "green" "teal" "blue" "all" ] themeVariants
lib.checkListOfEnum "${pname}: color variants" [ "standard" "light" "dark" ] colorVariants
lib.checkListOfEnum "${pname}: size variants" [ "standard" "compact" ] sizeVariants
lib.checkListOfEnum "${pname}: tweaks" [ "nord" "black" "dark" "rimless" "normal" ] tweaks
lib.checkListOfEnum "${pname}: grub screens" [ "1080p" "2k" "4k" ] grubScreens

stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "2022-03-22";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "7ab6a1b7eda81e914405a9931408b1d5c73e6891";
    sha256 = "maYHA+AICoPiZo62IJ52UFUhOZh+6m2e9z6Kz0zrsSc=";
  };

  nativeBuildInputs = [
    jdupes
    sassc
  ];

  buildInputs = [
    gnome-themes-extra
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  installPhase = ''
    runHook preInstall

    patchShebangs install.sh

    name= ./install.sh \
      ${lib.optionalString (themeVariants != []) "--theme " + builtins.toString themeVariants} \
      ${lib.optionalString (colorVariants != []) "--color " + builtins.toString colorVariants} \
      ${lib.optionalString (sizeVariants != []) "--size " + builtins.toString sizeVariants} \
      ${lib.optionalString (tweaks != []) "--tweaks " + builtins.toString tweaks} \
      --dest $out/share/themes

    ${lib.optionalString wallpapers ''
      mkdir -p $out/share/backgrounds
      cp -a wallpaper/Graphite-normal/*.png $out/share/backgrounds/
      ${lib.optionalString (builtins.elem "nord" tweaks) ''
        cp -a wallpaper/Graphite-nord/*.png $out/share/backgrounds/
      ''}
    ''}

    ${lib.optionalString withGrub ''
      (
      cd other/grub2

      patchShebangs install.sh

      ./install.sh --justcopy --dest $out/share/grub/themes \
        ${lib.optionalString (builtins.elem "nord" tweaks) "--theme nord"} \
        ${lib.optionalString (grubScreens != []) "--screen " + builtins.toString grubScreens}
      )
    ''}

    jdupes -L -r $out/share

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { inherit pname version; };

  meta = with lib; {
    description = "Flat Gtk+ theme based on Elegant Design";
    homepage = "https://github.com/vinceliuice/Graphite-gtk-theme";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
