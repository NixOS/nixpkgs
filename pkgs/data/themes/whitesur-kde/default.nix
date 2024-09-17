{ lib
, stdenvNoCC
, fetchFromGitHub
, plasma-desktop
, qtsvg
, unstableGitUpdater
}:

stdenvNoCC.mkDerivation {
  pname = "whitesur-kde";
  version = "2022-05-01-unstable-2024-09-10";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "whitesur-kde";
    rev = "3d80dc97fd3008c4648937f8d7e39014f874a7eb";
    hash = "sha256-jkK15evuYi1x+9MMERlp/F4O2AxQPHdrm4qBlzIPROM=";
  };

  # Propagate sddm theme dependencies to user env otherwise sddm does
  # not find them. Putting them in buildInputs is not enough.
  propagatedUserEnvPkgs = [
    plasma-desktop
    qtsvg
  ];

  postPatch = ''
    patchShebangs install.sh sddm/install.sh

    substituteInPlace install.sh \
      --replace-fail '[ "$UID" -eq "$ROOT_UID" ]' true \
      --replace-fail /usr $out \
      --replace-fail '"$HOME"/.Xresources' $out/doc/.Xresources

    substituteInPlace sddm/install.sh \
      --replace-fail '[ "$UID" -eq "$ROOT_UID" ]' true \
      --replace-fail /usr $out \
      --replace-fail 'REO_DIR="$(cd $(dirname $0) && pwd)"' 'REO_DIR=sddm'

    substituteInPlace sddm/*/Main.qml \
      --replace-fail /usr $out
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/doc
    name= ./install.sh

    mkdir -p $out/share/sddm/themes
    sddm/install.sh

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "MacOS big sur like theme for KDE Plasma desktop";
    homepage = "https://github.com/vinceliuice/WhiteSur-kde";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
