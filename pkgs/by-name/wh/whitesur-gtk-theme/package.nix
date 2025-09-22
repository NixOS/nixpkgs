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
  schemeVariants ? [ ], # default: standard
  iconVariant ? null, # default: standard (Apple logo)
  nautilusStyle ? null, # default: stable (BigSur-like style)
  panelOpacity ? null, # default: 15%
  panelSize ? null, # default: 32px
  roundedMaxWindow ? false, # default: false
  darkerColor ? false, # default = false
}:

let
  pname = "whitesur-gtk-theme";
  single = x: lib.optional (x != null) x;

in
lib.checkListOfEnum "${pname}: window control buttons variants" [ "normal" "alt" "all" ] altVariants
  lib.checkListOfEnum
  "${pname}: color variants"
  [ "light" "dark" ]
  colorVariants
  lib.checkListOfEnum
  "${pname}: opacity variants"
  [ "normal" "solid" ]
  opacityVariants
  lib.checkListOfEnum
  "${pname}: accent color variants"
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
  "${pname}: colorscheme style variants"
  [ "standard" "nord" ]
  schemeVariants
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
  [ "stable" "normal" "mojave" "glassy" "right" ]
  (single nautilusStyle)
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
    version = "2025-07-24";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "whitesur-gtk-theme";
      rev = version;
      hash = "sha256-tuon9XxMdrz9XNTp50sbss2gtx6H9hEZh8t2jSoqx28=";
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
      substituteInPlace libs/lib-core.sh --replace-fail '$(which sudo)' false

      # Provides a dummy home directory
      substituteInPlace libs/lib-core.sh --replace-fail 'MY_HOME=$(getent passwd "''${MY_USERNAME}" | cut -d: -f6)' 'MY_HOME=/tmp'
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
        ${toString (map (x: "--scheme " + x) schemeVariants)} \
        ${lib.optionalString (nautilusStyle != null) ("--nautilus " + nautilusStyle)} \
        ${lib.optionalString roundedMaxWindow "--roundedmaxwindow"} \
        ${lib.optionalString darkerColor "--darkercolor"} \
        ${lib.optionalString (iconVariant != null) ("--gnome-shell -i " + iconVariant)} \
        ${lib.optionalString (panelSize != null) ("--gnome-shell -panelheight " + panelSize)} \
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
