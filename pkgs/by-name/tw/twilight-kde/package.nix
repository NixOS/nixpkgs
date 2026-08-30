{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "twilight-kde";
  version = "0-unstable-2023-03-09";

  src = fetchFromGitHub {
    owner = "yeyushengfan258";
    repo = "Twilight-kde";
    rev = "a5fc50a040693a53472d83d2d47e964d2cf2bcd3";
    hash = "sha256-b9//jWOD9TPOBPIDl/66j6wsWvo82h6wsee0JoQcBD0=";
  };

  postPatch = ''
    patchShebangs install.sh

    substituteInPlace install.sh \
      --replace '$HOME/.local' $out \
      --replace '$HOME/.config' $out/share
  '';

  installPhase = ''
    runHook preInstall

    bash ./install.sh

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Light, clean theme for KDE Plasma desktop";
    homepage = "https://github.com/yeyushengfan258/Twilight-kde";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ dretyuiop ];
  };
}
