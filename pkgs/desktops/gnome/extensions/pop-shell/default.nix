{
  stdenv,
  lib,
  fetchFromGitHub,
  glib,
  gjs,
  typescript,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "gnome-shell-extension-pop-shell";
  version = "1.2.0-unstable-2025-10-01";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "shell";
    rev = "3cb093b8e6a36c48dd5e84533dc874ea74cd8a9e";
    hash = "sha256-FNNc3RY+x6y4bRU9BCUcQdzkG6iM8kKeRGkziQrTUM0=";
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
