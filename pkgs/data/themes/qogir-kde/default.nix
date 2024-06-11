{ lib
, stdenvNoCC
, fetchFromGitHub
, kdeclarative
, plasma-framework
, plasma-workspace
, gitUpdater
}:

stdenvNoCC.mkDerivation rec {
  pname = "qogir-kde";
  version = "unstable-2023-10-20";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "1cfe8da54e6f76d5ce0d2234dcb4f5186431edb3";
    hash = "sha256-Ts8cS7dH8RkfRgWvzDKLCC2G6Hsnvx0NAGstfxMIt+Y=";
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

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Flat Design theme for KDE Plasma desktop";
    homepage = "https://github.com/vinceliuice/Qogir-kde";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
