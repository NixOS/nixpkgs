{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, glib
, gtk-engine-murrine
, gtk_engines
, inkscape
, jdupes
, optipng
, sassc
, which
, buttonSizeVariants ? [] # default to standard
, buttonVariants ? [] # default to all
, colorVariants ? [] # default to all
, opacityVariants ? [] # default to all
, themeVariants ? [] # default to MacOS blue
, wallpapers ? false
}:

let
  pname = "mojave-gtk-theme";
in
lib.checkListOfEnum "${pname}: button size variants" [ "standard" "small" ] buttonSizeVariants
lib.checkListOfEnum "${pname}: button variants" [ "standard" "alt" ] buttonVariants
lib.checkListOfEnum "${pname}: color variants" [ "light" "dark" ] colorVariants
lib.checkListOfEnum "${pname}: opacity variants" [ "standard" "solid" ] opacityVariants
lib.checkListOfEnum "${pname}: theme variants" [ "default" "blue" "purple" "pink" "red" "orange" "yellow" "green" "grey" "all" ] themeVariants

stdenv.mkDerivation rec {
  inherit pname;
  version = "unstable-2021-12-20";

  srcs = [
    (fetchFromGitHub {
      owner = "vinceliuice";
      repo = pname;
      rev = "c148646ccab382f7a2d5fdc421fc32d843cb4172";
      sha256 = "sha256-h4MSSh8cu9M81bM+WJSyl1SQ7CVth1DvjIVOUJXqpxs";
    })
  ]
  ++
  lib.optional wallpapers
    (fetchurl {
      url = "https://github.com/vinceliuice/Mojave-gtk-theme/raw/11741a99d96953daf9c27e44c94ae50a7247c0ed/macOS_Mojave_Wallpapers.tar.xz";
      sha256 = "18zzkwm1kqzsdaj8swf0xby1n65gxnyslpw4lnxcx1rphip0rwf7";
    })
  ;

  sourceRoot = "source";

  nativeBuildInputs = [
    glib
    inkscape
    jdupes
    optipng
    sassc
    which
  ];

  buildInputs = [
    gtk_engines
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  # These fixup steps are slow and unnecessary.
  dontPatchELF = true;
  dontRewriteSymlinks = true;

  postPatch = ''
    patchShebangs .

    for f in \
      render-assets.sh \
      src/assets/cinnamon/thumbnails/render-thumbnails.sh \
      src/assets/gtk-2.0/render-assets.sh \
      src/assets/gtk/common-assets/render-assets.sh \
      src/assets/gtk/thumbnails/render-thumbnails.sh \
      src/assets/gtk/windows-assets/render-alt-assets.sh \
      src/assets/gtk/windows-assets/render-alt-small-assets.sh \
      src/assets/gtk/windows-assets/render-assets.sh \
      src/assets/gtk/windows-assets/render-small-assets.sh \
      src/assets/metacity-1/render-assets.sh \
      src/assets/xfwm4/render-assets.sh
    do
      substituteInPlace $f \
        --replace /usr/bin/inkscape ${inkscape}/bin/inkscape \
        --replace /usr/bin/optipng ${optipng}/bin/optipng
    done
  '';

  installPhase = ''
    runHook preInstall

    name= ./install.sh \
      ${lib.optionalString (buttonSizeVariants != []) "--small " + builtins.toString buttonSizeVariants} \
      ${lib.optionalString (buttonVariants != []) "--alt " + builtins.toString buttonVariants} \
      ${lib.optionalString (colorVariants != []) "--color " + builtins.toString colorVariants} \
      ${lib.optionalString (opacityVariants != []) "--opacity " + builtins.toString opacityVariants} \
      ${lib.optionalString (themeVariants != []) "--theme " + builtins.toString themeVariants} \
      --dest $out/share/themes

    ${lib.optionalString wallpapers ''
      install -D -t $out/share/wallpapers ../"macOS Mojave Wallpapers"/*
    ''}

    # Replace duplicate files with hardlinks to the first file in each
    # set of duplicates, reducing the installed size in about 53%
    jdupes -L -r $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "Mac OSX Mojave like theme for GTK based desktop environments";
    homepage = "https://github.com/vinceliuice/Mojave-gtk-theme";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
