{ lib
, stdenvNoCC
, fetchFromGitHub
, glib
, gnome-shell
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
, gitUpdater
}:

let

  pname = "mojave-gtk-theme";
  version = "2023-08-04";

  main_src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    hash = "sha256-boS/GPjuJV5lZjyHW7tG74T6a3SASQVGnSz++5HkCuw=";
  };

  wallpapers_src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "1dc23c2b45d7e073e080cfb02f43aab0e59b6b2c";
    hash = "sha256-nkw8gXYx8fN1yn0A5M2fWwOvfUQ6izynxRw5JA61InM=";
    name = "wallpapers";
  };

in

lib.checkListOfEnum "${pname}: button size variants" [ "standard" "small" ] buttonSizeVariants
lib.checkListOfEnum "${pname}: button variants" [ "standard" "alt" ] buttonVariants
lib.checkListOfEnum "${pname}: color variants" [ "light" "dark" ] colorVariants
lib.checkListOfEnum "${pname}: opacity variants" [ "standard" "solid" ] opacityVariants
lib.checkListOfEnum "${pname}: theme variants" [ "default" "blue" "purple" "pink" "red" "orange" "yellow" "green" "grey" "all" ] themeVariants

stdenvNoCC.mkDerivation rec {
  inherit pname version;

  srcs = [ main_src ] ++ lib.optional wallpapers wallpapers_src;

  sourceRoot = main_src.name;

  nativeBuildInputs = [
    glib
    gnome-shell
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
    patchShebangs \
      install.sh \
      src/main/gtk-3.0/make_gresource_xml.sh \
      src/main/gtk-4.0/make_gresource_xml.sh

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
      patchShebangs $f
      substituteInPlace $f \
        --replace /usr/bin/inkscape ${inkscape}/bin/inkscape \
        --replace /usr/bin/optipng ${optipng}/bin/optipng
    done

    ${lib.optionalString wallpapers ''
      for f in ../${wallpapers_src.name}/Mojave{,-timed}.xml; do
        substituteInPlace $f --replace /usr $out
      done
    ''}
  '';

  installPhase = ''
    runHook preInstall

    name= ./install.sh \
      ${lib.optionalString (buttonSizeVariants != []) "--small " + builtins.toString buttonSizeVariants} \
      ${lib.optionalString (buttonVariants != []) "--alt " + builtins.toString buttonVariants} \
      ${lib.optionalString (colorVariants != []) "--color " + builtins.toString colorVariants} \
      ${lib.optionalString (opacityVariants != []) "--opacity " + builtins.toString opacityVariants} \
      ${lib.optionalString (themeVariants != []) "--theme " + builtins.toString themeVariants} \
      --icon nixos \
      --dest $out/share/themes

    ${lib.optionalString wallpapers ''
      mkdir -p $out/share/backgrounds/Mojave
      mkdir -p $out/share/gnome-background-properties
      cp -a ../${wallpapers_src.name}/Mojave*.jpeg $out/share/backgrounds/Mojave/
      cp -a ../${wallpapers_src.name}/Mojave-timed.xml $out/share/backgrounds/Mojave/
      cp -a ../${wallpapers_src.name}/Mojave.xml $out/share/gnome-background-properties/
    ''}

    # Replace duplicate files with soft links to the first file in each
    # set of duplicates, reducing the installed size in about 53%
    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Mac OSX Mojave like theme for GTK based desktop environments";
    homepage = "https://github.com/vinceliuice/Mojave-gtk-theme";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
