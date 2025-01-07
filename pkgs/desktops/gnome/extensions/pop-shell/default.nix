{
  stdenv,
  lib,
  fetchFromGitHub,
  glib,
  gjs,
  typescript,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-pop-shell";
  version = "1.2.0-unstable-2024-12-31";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "shell";
    rev = "104269ede04d52caf98734b199d960a3b25b88df";
    hash = "sha256-rBu/Nn7e03Pvw0oZDL6t+Ms0nesCyOm4GiFY6aYM+HI=";
  };

  nativeBuildInputs = [
    glib
    gjs
    typescript
  ];

  buildInputs = [ gjs ];

  patches = [
    ./fix-gjs.patch
  ];

  makeFlags = [ "XDG_DATA_HOME=$(out)/share" ];

  passthru = {
    extensionUuid = "pop-shell@system76.com";
    extensionPortalSlug = "pop-shell";
    updateScript = unstableGitUpdater { };
  };

  postPatch = ''
    for file in */main.js; do
      substituteInPlace $file --replace "gjs" "${gjs}/bin/gjs"
    done
  '';

  preFixup = ''
    chmod +x $out/share/gnome-shell/extensions/pop-shell@system76.com/*/main.js
  '';

  meta = with lib; {
    description = "Keyboard-driven layer for GNOME Shell";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.genofire ];
    homepage = "https://github.com/pop-os/shell";
  };
}
