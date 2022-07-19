{ lib
, stdenvNoCC
, fetchFromGitHub
, gitUpdater
, gtk3
, hicolor-icon-theme
, jdupes
}:

stdenvNoCC.mkDerivation rec {
  pname = "qogir-icon-theme";
  version = "2022-07-20";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "sha256-I+eojCTR3fXcp7v5Bdie9vstmJja9HB71aQSF5jLDD4=";
  };

  nativeBuildInputs = [ gtk3 jdupes ];

  propagatedBuildInputs = [ hicolor-icon-theme ];

  dontDropIconThemeCache = true;

  # These fixup steps are slow and unnecessary.
  dontPatchELF = true;
  dontRewriteSymlinks = true;

  postPatch = ''
    patchShebangs install.sh
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    name= ./install.sh -d $out/share/icons

    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { inherit pname version; };

  meta = with lib; {
    description = "Flat colorful design icon theme";
    homepage = "https://github.com/vinceliuice/Qogir-icon-theme";
    license = with licenses; [ gpl3Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
