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
  version = "0-unstable-2024-06-28";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "5224dbdeed76c5ed4b7b5ff6d0b48ebe82547228";
    hash = "sha256-qS0bVfweSXv2Sox3cXQ8PfcPD+WA6kwrEoS0ijxWZE8=";
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
