{ lib
, stdenvNoCC
, fetchFromGitHub
, gnome-themes-extra
, gtk-engine-murrine
, jdupes
, sassc
, themeVariants ? [] # default: blue
, colorVariants ? [] # default: all
, sizeVariants ? [] # default: standard
, tweaks ? []
, wallpapers ? false
}:

let
  pname = "graphite-gtk-theme";

in
lib.checkListOfEnum "${pname}: theme variants" [ "default" "purple" "pink" "red" "orange" "yellow" "green" "teal" "blue" "all" ] themeVariants
lib.checkListOfEnum "${pname}: color variants" [ "standard" "light" "dark" ] colorVariants
lib.checkListOfEnum "${pname}: size variants" [ "standard" "compact" ] sizeVariants
lib.checkListOfEnum "${pname}: tweaks" [ "nord" "black" "midblack" "rimless" "normal" ] tweaks

stdenvNoCC.mkDerivation {
  inherit pname;
  version = "unstable-2022-01-07";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "78e5421fee63b4c2a2a3d2e321538367b01a24ec";
    sha256 = "1vfvv1gfbr9yr9mz0kb7c7ij6pxcryni1fjs87gn4hpyzns431wk";
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

    jdupes -L -r $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "Flat Gtk+ theme based on Elegant Design";
    homepage = "https://github.com/vinceliuice/Graphite-gtk-theme";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
