{ stdenv
, lib
, fetchFromGitHub
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "layan-kde";
  version = "2022-02-13";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "09z90g13l26v23nwr8n5bapwldp3hhdrdikynvm4vvb7qsvb4vrp";
  };

  postPatch = ''
    patchShebangs install.sh

    substituteInPlace install.sh \
      --replace '$HOME/.local' $out \
      --replace '$HOME/.config' $out/share
  '';

  installPhase = ''
    runHook preInstall

    name= ./install.sh --dest $out/share/themes

    mkdir -p $out/share/sddm/themes
    cp -a sddm/Layan* $out/share/sddm/themes/

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {inherit pname version; };

  meta = with lib; {
    description = "A flat Design theme for KDE Plasma desktop";
    homepage = "https://github.com/vinceliuice/Layan-kde";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
