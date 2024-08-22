{ lib
, stdenvNoCC
, fetchFromGitHub
, plasma-desktop
, qtsvg
, unstableGitUpdater
}:

stdenvNoCC.mkDerivation {
  pname = "whitesur-kde";
  version = "2022-05-01-unstable-2024-08-07";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "whitesur-kde";
    rev = "a5c704224069a9e10fce82eec3c4ba482924d7ef";
    hash = "sha256-GGrddhmYOp2qm1rHyBnSjQIyw0pU7CNJhxUt6da8ZpQ=";
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
