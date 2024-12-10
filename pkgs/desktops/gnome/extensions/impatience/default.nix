{
  lib,
  stdenv,
  fetchFromGitHub,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-impatience";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "timbertson";
    repo = "gnome-shell-impatience";
    rev = "refs/tags/version-${version}";
    hash = "sha256-yBRnhdCDeA0bL+kkrmnIqyXAlhZzO2Vthc4Dnba80j4=";
  };

  buildInputs = [
    glib
  ];

  buildPhase = ''
    runHook preBuild
    make schemas
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r impatience "$out/share/gnome-shell/extensions/impatience@gfxmonk.net"
    runHook postInstall
  '';

  passthru = {
    extensionUuid = "impatience@gfxmonk.net";
    extensionPortalSlug = "impatience";
  };

  meta = with lib; {
    description = "Speed up builtin gnome-shell animations";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      timbertson
      tiramiseb
    ];
    homepage = "http://gfxmonk.net/dist/0install/gnome-shell-impatience.xml";
  };
}
