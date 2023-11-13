{ lib
, stdenvNoCC
, fetchFromGitHub
, gitUpdater
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "whitesur-kde";
  version = "unstable-2023-08-15";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = finalAttrs.pname;
    rev = "d50bc20b2b78705bb9856204066affb763fa8a35";
    hash = "sha256-oG6QT4VQpBznM+gvzdiY4CldOwdHcBeHlbvlc52eFuU=";
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
