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
  version = "1.2.0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "shell";
    rev = "7898b65c20735057faf0797f8ed056704ca55f0d";
    hash = "sha256-MmHoOxymo0QSRbRcSbFiv82+QWAwIwXwg/wyGQGVYiI=";
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

  meta = {
    description = "Keyboard-driven layer for GNOME Shell";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.genofire ];
    homepage = "https://github.com/pop-os/shell";
  };
}
