{ lib
, stdenvNoCC
, fetchFromGitHub
, gitUpdater
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "whitesur-kde";
  version = "unstable-2023-10-06";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = finalAttrs.pname;
    rev = "2b4bcc76168bd8a4a7601188e177fa0ab485cdc8";
    hash = "sha256-+Iooj8a7zfLhEWnjLEVoe/ebD9Vew5HZdz0wpWVZxA8=";
  };

  postPatch = ''
    patchShebangs install.sh

    substituteInPlace install.sh \
      --replace '$HOME/.config' $out/share \
      --replace '$HOME/.local' $out \
      --replace '"$HOME"/.Xresources' $out/doc/.Xresources
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/doc

    name= ./install.sh

    mkdir -p $out/share/sddm/themes
    cp -a sddm/WhiteSur $out/share/sddm/themes/

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "A MacOS big sur like theme for KDE Plasma desktop";
    homepage = "https://github.com/vinceliuice/WhiteSur-kde";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
})
