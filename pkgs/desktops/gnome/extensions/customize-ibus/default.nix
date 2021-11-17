{ lib, stdenv, fetchFromGitHub, gnome, gettext, glib, ibus }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-customize-ibus";
  version = "78";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "Customize-IBus";
    rev = "v${version}";
    sha256 = "1hnnsjriq7xaakk8biwz55mn077lnm9nsmi4wz5zk7clgxmasvq9";
  };

  passthru = {
    extensionUuid = "customize-ibus@hollowman.ml";
    extensionPortalSlug = "customize-ibus";
  };

  nativeBuildInputs = [ gettext glib ];

  buildPhase = ''
    runHook preBuild
    make _build VERSION=${version}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/gnome-shell/extensions/"
    cp -r _build "$out/share/gnome-shell/extensions/customize-ibus@hollowman.ml"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Full customization of appearance, behavior, system tray and input source indicator for IBus";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hollowman6 ];
    homepage = "https://github.com/openSUSE/Customize-IBus";
    broken = versionOlder gnome.gnome-shell.version "3.34";
  };
}
