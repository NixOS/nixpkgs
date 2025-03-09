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
  version = "1.2.0-unstable-2024-10-09";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "shell";
    rev = "e25621e2595eb5235ecb1a41167d1324a2b2a297";
    hash = "sha256-PPJofRzzbH1zcnKtQ/3ulErvN4pAJMo/igzdq1zT06s=";
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
