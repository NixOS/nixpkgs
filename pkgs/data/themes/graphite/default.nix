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

  throwIfNotSubList = name: given: valid:
    let
      unexpected = lib.subtractLists valid given;
    in
      lib.throwIfNot (unexpected == [])
        "${name}: ${builtins.concatStringsSep ", " (builtins.map builtins.toString unexpected)} unexpected; valid ones: ${builtins.concatStringsSep ", " (builtins.map builtins.toString valid)}";

in
throwIfNotSubList "${pname}: theme variants" themeVariants [ "default" "purple" "pink" "red" "orange" "yellow" "green" "teal" "blue" "all" ]
throwIfNotSubList "${pname}: color variants" colorVariants [ "standard" "light" "dark" ]
throwIfNotSubList "${pname}: size variants" sizeVariants [ "standard" "compact" ]
throwIfNotSubList "${pname}: tweaks" tweaks [ "nord" "black" "midblack" "rimless" "normal" ]

stdenvNoCC.mkDerivation {
  inherit pname;
  version = "unstable-2022-01-04";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "947cac4966377d8f5b5a4e2966ec2b9a6041d205";
    sha256 = "11pl8hzk4fwniqdib0ffvjilpspr1n5pg1gw39kal13wxh4sdg28";
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
