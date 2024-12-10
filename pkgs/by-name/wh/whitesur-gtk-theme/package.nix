{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  dialog,
  glib,
  gnome-themes-extra,
  jdupes,
  libxml2,
  sassc,
  util-linux,
  altVariants ? [ ], # default: normal
  colorVariants ? [ ], # default: all
  opacityVariants ? [ ], # default: all
  themeVariants ? [ ], # default: default (BigSur-like theme)
  iconVariant ? null, # default: standard (Apple logo)
  nautilusStyle ? null, # default: stable (BigSur-like style)
  nautilusSize ? null, # default: 200px
  panelOpacity ? null, # default: 15%
  panelSize ? null, # default: 32px
  roundedMaxWindow ? false, # default: false
  nordColor ? false, # default = false
  darkerColor ? false, # default = false
}:

let
  pname = "whitesur-gtk-theme";
  single = x: lib.optional (x != null) x;

in
lib.checkListOfEnum "${pname}: alt variants" [ "normal" "alt" "all" ] altVariants
  lib.checkListOfEnum
  "${pname}: color variants"
  [ "Light" "Dark" ]
  colorVariants
  lib.checkListOfEnum
  "${pname}: opacity variants"
  [ "normal" "solid" ]
  opacityVariants
  lib.checkListOfEnum
  "${pname}: theme variants"
  [
    "default"
    "blue"
    "purple"
    "pink"
    "red"
    "orange"
    "yellow"
    "green"
    "grey"
    "all"
  ]
  themeVariants
  lib.checkListOfEnum
  "${pname}: activities icon variants"
  [
    "standard"
    "apple"
    "simple"
    "gnome"
    "ubuntu"
    "tux"
    "arch"
    "manjaro"
    "fedora"
    "debian"
    "void"
    "opensuse"
    "popos"
    "mxlinux"
    "zorin"
    "budgie"
    "gentoo"
  ]
  (single iconVariant)
  lib.checkListOfEnum
  "${pname}: nautilus style"
  [ "stable" "normal" "mojave" "glassy" ]
  (single nautilusStyle)
  lib.checkListOfEnum
  "${pname}: nautilus sidebar minimum width"
  [ "default" "180" "220" "240" "260" "280" ]
  (single nautilusSize)
  lib.checkListOfEnum
  "${pname}: panel opacity"
  [ "default" "30" "45" "60" "75" ]
  (single panelOpacity)
  lib.checkListOfEnum
  "${pname}: panel size"
  [ "default" "smaller" "bigger" ]
  (single panelSize)

  stdenv.mkDerivation
  rec {
    pname = "whitesur-gtk-theme";
    version = "2024.09.02";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = pname;
      rev = version;
      hash = "sha256-a32iHPcbMYuBy65FWm/fkjwJQE3aVScR3WJJzKTVx9k=";
    };

    nativeBuildInputs = [
      dialog
      glib
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
      substituteInPlace shell/lib-core.sh --replace-fail '$(which sudo)' false

      # Provides a dummy home directory
      substituteInPlace shell/lib-core.sh --replace-fail 'MY_HOME=$(getent passwd "''${MY_USERNAME}" | cut -d: -f6)' 'MY_HOME=/tmp'
    '';

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/themes

      ./install.sh \
        ${toString (map (x: "--alt " + x) altVariants)} \
        ${toString (map (x: "--color " + x) colorVariants)} \
        ${toString (map (x: "--opacity " + x) opacityVariants)} \
        ${toString (map (x: "--theme " + x) themeVariants)} \
        ${lib.optionalString (nautilusStyle != null) ("--nautilus " + nautilusStyle)} \
        ${lib.optionalString (nautilusSize != null) ("--size " + nautilusSize)} \
        ${lib.optionalString roundedMaxWindow "--roundedmaxwindow"} \
        ${lib.optionalString nordColor "--nordcolor"} \
        ${lib.optionalString darkerColor "--darkercolor"} \
        ${lib.optionalString (iconVariant != null) ("--gnome-shell -i " + iconVariant)} \
        ${lib.optionalString (panelSize != null) ("--gnome-shell -height " + panelSize)} \
        ${lib.optionalString (panelOpacity != null) ("--gnome-shell -panelopacity " + panelOpacity)} \
        --dest $out/share/themes

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    passthru.updateScript = gitUpdater { };

    meta = {
      description = "MacOS BigSur like Gtk+ theme based on Elegant Design";
      homepage = "https://github.com/vinceliuice/WhiteSur-gtk-theme";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ romildo ];
    };
  }
