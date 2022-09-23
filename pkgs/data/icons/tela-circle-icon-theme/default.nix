{ lib
, stdenvNoCC
, fetchFromGitHub
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
lib.checkListOfEnum "${pname}: color variants" [ "standard" "black" "blue" "brown" "green" "grey" "orange" "pink" "purple" "red" "yellow" "manjaro" "ubuntu" ] colorVariants

stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "2022-03-07";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "vQeWGZmurvT/UQJ1dx6t+ZeKdJ1Oq9TdHBADw64x18g=";
  };

  nativeBuildInputs = [
    gtk3
    jdupes
  ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  # These fixup steps are slow and unnecessary for this package.
  # Package may install almost 400 000 small files.
  dontPatchELF = true;
  dontRewriteSymlinks = true;

  installPhase = ''
    runHook preInstall

    patchShebangs install.sh

    ./install.sh -d $out/share/icons \
      ${lib.optionalString circularFolder "-c"} \
      ${if allColorVariants then "-a" else builtins.toString colorVariants}

    jdupes --link-soft --recurse $out/share

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {inherit pname version; };

  meta = with lib; {
    description = "Flat and colorful personality icon theme";
    homepage = "https://github.com/vinceliuice/Tela-circle-icon-theme";
    license = licenses.gpl3Only;
    platforms = platforms.linux; # darwin use case-insensitive filesystems that cause hash mismatches
    maintainers = with maintainers; [ romildo ];
  };
}
