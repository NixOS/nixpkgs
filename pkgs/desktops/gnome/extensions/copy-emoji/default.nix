{ lib, stdenv, fetchFromGitHub, glib, gettext }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-emoji-copy";
  version = "v0.2.2";

  src = fetchFromGitHub {
    owner = "FelipeFTN";
    repo = "emoji-copy";
    rev = version;
    sha256 = "sha256-sD/xlNrs2ntI7KaPMopT5CnFyuXd9ZKuKPNQYgiho0U=";
  };

  passthru = {
    extensionUuid = "emoji-copy@felipeftn";
    extensionPortalSlug = "emoji-copy";
  };

  nativeBuildInputs = [ glib ];

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas "./emoji-copy@felipeftn/schemas"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r "emoji-copy@felipeftn" $out/share/gnome-shell/extensions
    runHook postInstall
  '';

  meta = with lib; {
    description =
      "Emoji copy is a versatile extension designed to simplify emoji selection and clipboard management. ";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KiaraGrouwstra ];
    homepage = "https://github.com/FelipeFTN/emoji-copy";
  };
}
