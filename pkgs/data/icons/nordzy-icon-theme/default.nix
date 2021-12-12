{ stdenv
, fetchFromGitHub
, lib
, bash
, gtk3
, nordzy-themes ? [ "all" ] # Override this to only install selected themes
}:

let
  themes-arg-string = lib.strings.concatMapStrings (theme: "-t ${theme} ") nordzy-themes;
in
stdenv.mkDerivation rec {
  pname = "nordzy-icon-theme";
  version = "unstable-2021-12-14";

  src = fetchFromGitHub {
    owner = "alvatip";
    repo = "Nordzy-icon";
    rev = "5c247a4f19cf9849615631d1bf77727b945b634e";
    sha256 = "Jqn5CF80xlYJ7H4qI1VEj91vcKPPoMXP5+sPs0ksiC4=";
  };

  nativeBuildInputs = [ gtk3 ];

  postPatch = ''
    substituteInPlace install.sh \
      --replace /bin/bash ${bash}/bin/bash
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    ./install.sh --dest $out/share/icons \
      -n Nordzy \
      -t ${themes-arg-string}

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
