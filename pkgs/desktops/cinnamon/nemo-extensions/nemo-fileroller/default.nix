{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
  glib,
  gtk3,
  nemo,
  gnome,
  cinnamon-translations,
}:

let
  srcs = import ../srcs.nix { inherit fetchFromGitHub; };
in
stdenv.mkDerivation rec {
  pname = "nemo-fileroller";
  inherit (srcs) version src;

  sourceRoot = "${src.name}/nemo-fileroller";

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  buildInputs = [
    glib
    gtk3
    nemo
  ];

  postPatch = ''
    substituteInPlace src/nemo-fileroller.c \
      --replace "file-roller" "${lib.getExe gnome.file-roller}" \
      --replace "GNOMELOCALEDIR" "${cinnamon-translations}/share/locale"
  '';

  PKG_CONFIG_LIBNEMO_EXTENSION_EXTENSIONDIR = "${placeholder "out"}/${nemo.extensiondir}";

  meta = with lib; {
    homepage = "https://github.com/linuxmint/nemo-extensions/tree/master/nemo-fileroller";
    description = "Nemo file roller extension";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
