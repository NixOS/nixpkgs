{ stdenvNoCC
, fetchFromGitHub
, lib
, bash
, gtk3
, nordzy-theme-name ? "Nordzy"
, nordzy-themes ? [ "all" ] # Override this to only install selected themes
}:

let
  themes-arg-string = lib.strings.concatMapStrings (theme: "-t ${theme} ") nordzy-themes;
in
stdenvNoCC.mkDerivation {
  pname = "nordzy-icon-theme";
  version = "unstable-2021-12-14";

  src = fetchFromGitHub {
    owner = "alvatip";
    repo = "Nordzy-icon";
    rev = "5c247a4f19cf9849615631d1bf77727b945b634e";
    sha256 = "Jqn5CF80xlYJ7H4qI1VEj91vcKPPoMXP5+sPs0ksiC4=";
  };

  # In the post patch phase we should fir st make sure to patch shebangs.
  # We can also remove the gtk-update-icon-cache since the cache will later be built by the system.
  postPatch = ''
    patchShebangs install.sh
    substituteInPlace install.sh \
      --replace "gtk-update-icon-cache" "#"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    ./install.sh --dest $out/share/icons \
      -n ${nordzy-theme-name} \
      ${themes-arg-string}

    runHook postInstall
  '';

  dontFixup = true;

  meta = with lib; {
    description = "A free and open source icon theme using the Nord color palette and based on WhiteSur and Numix Icon Theme";
    homepage = "https://github.com/alvatip/Nordzy-icon";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [
      alexnortung
    ];
  };
}
