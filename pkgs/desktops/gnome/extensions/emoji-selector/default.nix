{ lib, stdenv, fetchFromGitHub, glib, gettext }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-emoji-selector";
  version = "20";

  src = fetchFromGitHub {
    owner = "maoschanz";
    repo = "emoji-selector-for-gnome";
    rev = version;
    sha256 = "sha256-I5aEHDC5GaGkAoH+1l4eyhBmJ+lmyZZoDw2Fq2SSlmo=";
  };

  passthru = {
    extensionUuid = "emoji-selector@maestroschan.fr";
    extensionPortalSlug = "emoji-selector";
  };

  nativeBuildInputs = [ glib ];

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas "./emoji-selector@maestroschan.fr/schemas"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r "emoji-selector@maestroschan.fr" $out/share/gnome-shell/extensions
    runHook postInstall
  '';

  meta = with lib; {
    description =
      "GNOME Shell extension providing a searchable popup menu displaying most emojis";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ rawkode ];
    homepage = "https://github.com/maoschanz/emoji-selector-for-gnome";
  };
}
