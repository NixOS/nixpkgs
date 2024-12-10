{
  stdenv,
  lib,
  fetchFromGitHub,
  kdeclarative,
  plasma-framework,
  plasma-workspace,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "layan-kde";
  version = "unstable-2023-09-30";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "7ab7cd7461dae8d8d6228d3919efbceea5f4272c";
    hash = "sha256-Wh8tZcQEdTTlgtBf4ovapojHcpPBZDDkWOclmxZv9zA=";
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

    name= ./install.sh --dest $out/share/themes

    mkdir -p $out/share/sddm/themes
    cp -a sddm/Layan* $out/share/sddm/themes/

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "A flat Design theme for KDE Plasma desktop";
    homepage = "https://github.com/vinceliuice/Layan-kde";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
