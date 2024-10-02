{ lib
, stdenvNoCC
, fetchFromGitHub
, kdeclarative
, plasma-framework
, plasma-workspace
, unstableGitUpdater
}:

stdenvNoCC.mkDerivation rec {
  pname = "qogir-kde";
  version = "0-unstable-2024-09-01";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "dff5c1fbbaa0b824684c65063b635cf27bcb19ce";
    hash = "sha256-uK9lJVRdMszA0am1/E4mfIN50yNKONH85M7+e0ERtn4=";
  };

  # Propagate sddm theme dependencies to user env otherwise sddm does
  # not find them. Putting them in buildInputs is not enough.
  propagatedUserEnvPkgs = [
    kdeclarative.bin
    plasma-framework
    plasma-workspace
  ];

  postPatch = ''
    patchShebangs install.sh

    substituteInPlace install.sh \
      --replace '$HOME/.local' $out \
      --replace '$HOME/.config' $out/share

    substituteInPlace sddm/*/Main.qml \
      --replace /usr $out
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plasma/plasmoids

    name= HOME="$TMPDIR" ./install.sh --dest $out/share/themes

    mkdir -p $out/share/sddm/themes
    cp -a sddm/Qogir $out/share/sddm/themes/

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Flat Design theme for KDE Plasma desktop";
    homepage = "https://github.com/vinceliuice/Qogir-kde";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
