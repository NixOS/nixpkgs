{ lib
, stdenv
, fetchFromGitHub
, gitUpdater
, glib
, gnome-shell
, gnome-themes-extra
, jdupes
, libxml2
, sassc
, util-linux
, altVariants ? [] # default: normal
, colorVariants ? [] # default: all
, opacityVariants ? [] # default: all
, themeVariants ? [] # default: default (BigSur-like theme)
, iconVariant ? null # default: standard (Apple logo)
, nautilusStyle ? null # default: stable (BigSur-like style)
, nautilusSize ? null # default: 200px
, panelOpacity ? null # default: 15%
, panelSize ? null # default: 32px
, roundedMaxWindow ? false # default: false
, nordColor ? false # default = false
, darkerColor ? false # default = false
}:

let
  pname = "whitesur-gtk-theme";
  single = x: lib.optional (x != null) x;

in
lib.checkListOfEnum "${pname}: alt variants" [ "normal" "alt" "all" ] altVariants
lib.checkListOfEnum "${pname}: color variants" [ "Light" "Dark" ] colorVariants
lib.checkListOfEnum "${pname}: opacity variants" [ "normal" "solid" ] opacityVariants
lib.checkListOfEnum "${pname}: theme variants" [ "default" "blue" "purple" "pink" "red" "orange" "yellow" "green" "grey" "all" ] themeVariants
lib.checkListOfEnum "${pname}: Activities icon variants" [ "standard" "simple" "gnome" "ubuntu" "tux" "arch" "manjaro" "fedora" "debian" "void" "opensuse" "popos" "mxlinux" "zorin" ] (single iconVariant)
lib.checkListOfEnum "${pname}: nautilus style" [ "stable" "normal" "mojave" "glassy" ] (single nautilusStyle)
lib.checkListOfEnum "${pname}: nautilus sidebar minimum width" [ "default" "180" "220" "240" "260" "280" ] (single nautilusSize)
lib.checkListOfEnum "${pname}: panel opacity" [ "default" "30" "45" "60" "75" ] (single panelOpacity)
lib.checkListOfEnum "${pname}: panel size" [ "default" "smaller" "bigger" ] (single panelSize)

stdenv.mkDerivation rec {
  pname = "whitesur-gtk-theme";
  version = "2024-02-26";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "sha256-9HYsORTd5n0jUYmwiObPZ90mOGhR2j+tzs6Y1NNnrn4=";
  };

  nativeBuildInputs = [
    glib
    gnome-shell
    jdupes
    libxml2
    sassc
    util-linux
  ];

  buildInputs = [
    gnome-themes-extra # adwaita engine for Gtk2
  ];

  postPatch = ''
    find -name "*.sh" -print0 | while IFS= read -r -d ''' file; do
      patchShebangs "$file"
    done

    # Do not provide `sudo`, as it is not needed in our use case of the install script
    substituteInPlace shell/lib-core.sh --replace '$(which sudo)' false

    # Provides a dummy home directory
    substituteInPlace shell/lib-core.sh --replace 'MY_HOME=$(getent passwd "''${MY_USERNAME}" | cut -d: -f6)' 'MY_HOME=/tmp'
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes

    ./install.sh  \
      ${toString (map (x: "--alt " + x) altVariants)} \
      ${toString (map (x: "--color " + x) colorVariants)} \
      ${toString (map (x: "--opacity " + x) opacityVariants)} \
      ${toString (map (x: "--theme " + x) themeVariants)} \
      ${lib.optionalString (iconVariant != null) ("--icon " + iconVariant)} \
      ${lib.optionalString (nautilusStyle != null) ("--nautilus-style " + nautilusStyle)} \
      ${lib.optionalString (nautilusSize != null) ("--size " + nautilusSize)} \
      ${lib.optionalString (panelOpacity != null) ("--panel-opacity " + panelOpacity)} \
      ${lib.optionalString (panelSize != null) ("--panel-size " + panelSize)} \
      ${lib.optionalString (roundedMaxWindow == true) "--roundedmaxwindow"} \
      ${lib.optionalString (nordColor == true) "--nordcolor"} \
      ${lib.optionalString (darkerColor == true) "--darkercolor"} \
      --dest $out/share/themes

    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "MacOS BigSur like Gtk+ theme based on Elegant Design";
    homepage = "https://github.com/vinceliuice/WhiteSur-gtk-theme";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
