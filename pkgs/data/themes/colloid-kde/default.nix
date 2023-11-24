{ lib
, stdenvNoCC
, fetchFromGitHub
, kdeclarative
, plasma-framework
, plasma-workspace
, gitUpdater
}:

stdenvNoCC.mkDerivation rec {
  pname = "colloid-kde";
  version = "unstable-2023-07-04";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "0b79befdad9b442b5a8287342c4b7e47ff87d555";
    hash = "sha256-AYH9fW20/p+mq6lxR1lcCV1BQ/kgcsjHncpMvYWXnWA=";
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

    substituteInPlace sddm/install.sh \
      --replace /usr $out \
      --replace '$(cd $(dirname $0) && pwd)' . \
      --replace '"$UID" -eq "$ROOT_UID"' true

    substituteInPlace sddm/Colloid/Main.qml \
      --replace /usr $out
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/latte

    name= HOME="$TMPDIR" \
    ./install.sh --dest $out/share/themes

    mkdir -p $out/share/sddm/themes
    cd sddm
    source install.sh

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "A clean and concise theme for KDE Plasma desktop";
    homepage = "https://github.com/vinceliuice/Colloid-kde-theme";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
