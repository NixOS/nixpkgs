{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  replaceVars,
  glib,
  gnome-shell,
  gettext,
  jq,
  intltool,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gnome-shell-extension-EasyScreenCast";
  version = "1.13.2";

  src = fetchFromGitHub {
    owner = "EasyScreenCast";
    repo = "EasyScreenCast";
    rev = finalAttrs.version;
    hash = "sha256-VYf5RHZHe6QIzQRW/oZ2tEHIo184xPqqx+hKAcCwOMg=";
  };

  patches = [
    (replaceVars ./fix-gi-path.patch {
      gnomeShell = gnome-shell;
    })
  ];

  nativeBuildInputs = [
    glib
    gettext
    jq
    intltool
  ];

  makeFlags = [ "INSTALLBASE=$(out)/share/gnome-shell/extensions" ];

  passthru = {
    extensionUuid = "EasyScreenCast@iacopodeenosee.gmail.com";
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simplifies the use of the video recording function integrated in gnome shell";
    homepage = "https://github.com/EasyScreenCast/EasyScreenCast";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
