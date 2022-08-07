{ lib
, stdenvNoCC
, fetchFromGitHub
, gitUpdater
}:

stdenvNoCC.mkDerivation rec {
  pname = "colloid-kde";
  version = "unstable-2022-07-13";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "eaf6844e997aa60c755af7ea560ffba798e72ff5";
    hash = "sha256-FNTG5aVvTWHqNVVR23LFG/ykPtXRD7oH5C6eyWaqc60=";
  };

  postPatch = ''
    patchShebangs install.sh

    substituteInPlace install.sh \
      --replace '$HOME/.local' $out \
      --replace '$HOME/.config' $out/share
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/latte

    name= HOME="$TMPDIR" \
    ./install.sh --dest $out/share/themes

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { inherit pname version; };

  meta = with lib; {
    description = "A clean and concise theme for KDE Plasma desktop";
    homepage = "https://github.com/vinceliuice/Colloid-kde-theme";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
