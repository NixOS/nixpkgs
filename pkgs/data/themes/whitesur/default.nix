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
, nautilusSize ? null # default: 200px
, panelOpacity ? null # default: 15%
, panelSize ? null # default: 32px
}:

let
  pname = "whitesur-gtk-theme";
  single = x: lib.optional (x != null) x;

in
lib.checkListOfEnum "${pname}: alt variants" [ "normal" "alt" "all" ] altVariants
lib.checkListOfEnum "${pname}: color variants" [ "light" "dark" ] colorVariants
lib.checkListOfEnum "${pname}: opacity variants" [ "normal" "solid" ] opacityVariants
lib.checkListOfEnum "${pname}: theme variants" [ "default" "blue" "purple" "pink" "red" "orange" "yellow" "green" "grey" "all" ] themeVariants
lib.checkListOfEnum "${pname}: nautilus sidebar minimum width" [ "default" "180" "220" "240" "260" "280" ] (single nautilusSize)
lib.checkListOfEnum "${pname}: panel opacity" [ "default" "30" "45" "60" "75" ] (single panelOpacity)
lib.checkListOfEnum "${pname}: panel size" [ "default" "smaller" "bigger" ] (single panelSize)

stdenv.mkDerivation rec {
  pname = "whitesur-gtk-theme";
  version = "2023-02-07";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "sha256-RGYD2+ZTUTPyFbaHvXU9VD3W6WTNeg3ifY+DAR3MmtI=";
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
      ${lib.optionalString (nautilusSize != null) ("--size " + nautilusSize)} \
      ${lib.optionalString (panelOpacity != null) ("--panel-opacity " + panelOpacity)} \
      ${lib.optionalString (panelSize != null) ("--panel-size " + panelSize)} \
      --dest $out/share/themes

    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "MacOS Big Sur like theme for Gnome desktops";
    homepage = "https://github.com/vinceliuice/WhiteSur-gtk-theme";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
