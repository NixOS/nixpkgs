{ lib
, stdenvNoCC
, fetchFromGitHub
, adwaita-icon-theme
, breeze-icons
, gtk3
, hicolor-icon-theme
, jdupes
, gitUpdater
, allColorVariants ? false
, circularFolder ? false
, colorVariants ? [] # default is standard
}:

let
  pname = "tela-circle-icon-theme";
in
lib.checkListOfEnum "${pname}: color variants" [ "standard" "black" "blue" "brown" "green" "grey" "orange" "pink" "purple" "red" "yellow" "manjaro" "ubuntu" "dracula" "nord" ] colorVariants

stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "2023-10-07";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    hash = "sha256-il+bYIcwm0BQF6U0J6h6rlzHSGSHYN/O8BezehYIpQ4=";
  };

  nativeBuildInputs = [
    gtk3
    jdupes
  ];

  propagatedBuildInputs = [
    adwaita-icon-theme
    breeze-icons
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  # These fixup steps are slow and unnecessary for this package.
  # Package may install almost 400 000 small files.
  dontPatchELF = true;
  dontRewriteSymlinks = true;

  postPatch = ''
    patchShebangs install.sh
  '';

  installPhase = ''
    runHook preInstall

    ./install.sh -d $out/share/icons \
      ${lib.optionalString circularFolder "-c"} \
      ${if allColorVariants then "-a" else builtins.toString colorVariants}

    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Flat and colorful personality icon theme";
    homepage = "https://github.com/vinceliuice/Tela-circle-icon-theme";
    license = licenses.gpl3Only;
    platforms = platforms.linux; # darwin use case-insensitive filesystems that cause hash mismatches
    maintainers = with maintainers; [ romildo ];
  };
}
