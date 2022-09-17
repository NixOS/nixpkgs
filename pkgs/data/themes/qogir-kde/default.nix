{ lib
, stdenvNoCC
, fetchFromGitHub
, gitUpdater
}:

stdenvNoCC.mkDerivation rec {
  pname = "qogir-kde";
  version = "unstable-2022-07-08";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "f240eae10978c7fee518f7a8be1c41a21a9d5c2e";
    hash = "sha256-AV60IQWwgvLwDO3ylILwx1DkKadwo4isn3JX3WpKoxQ=";
  };

  postPatch = ''
    patchShebangs install.sh

    substituteInPlace install.sh \
      --replace '$HOME/.local' $out \
      --replace '$HOME/.config' $out/share
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plasma/plasmoids

    name= HOME="$TMPDIR" ./install.sh --dest $out/share/themes

    mkdir -p $out/share/sddm/themes
    cp -a sddm/Qogir $out/share/sddm/themes/

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { inherit pname version; };

  meta = with lib; {
    description = "A flat Design theme for KDE Plasma desktop";
    homepage = "https://github.com/vinceliuice/Qogir-kde";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
