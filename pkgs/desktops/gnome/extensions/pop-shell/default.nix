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
  version = "1.2.0-unstable-2025-03-10";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "shell";
    rev = "b3fc4253dc29b30fb52ac5eef5d3af643a46d18c";
    hash = "sha256-EMX1AREpOO3DgxV/EbF2hP5JLggzlgFu1gsbhF3W1os=";
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
