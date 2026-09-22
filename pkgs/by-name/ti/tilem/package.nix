{
  stdenv,
  fetchFromGitHub,
  gnused,
  lib,
  nix-update,
  pkg-config,
  writeShellScript,
  glib,
  gtk3,
  wrapGAppsHook3,
  libticonv,
  libtifiles2,
  libticables2,
  libticalcs2,
}:

stdenv.mkDerivation {
  pname = "tilem";
  version = "2.1-unstable-2025-11-06";

  src = fetchFromGitHub {
    owner = "kuba160";
    repo = "tilem-gtk3";
    rev = "64b9a38a4460abf52bf09ab28dffdc3784f002a3";
    hash = "sha256-FYJMS2GIUbW89VrYbZM1+DLUGu86HxtScSWN0CLtNDo=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [
    glib
    gtk3
    libticonv
    libtifiles2
    libticables2
    libticalcs2
  ];

  env.NIX_CFLAGS_COMPILE = toString [ "-lm" ];

  passthru.updateScript = writeShellScript "update-tilem" ''
    ${lib.getExe nix-update} "$UPDATE_NIX_ATTR_PATH" --version=branch
    ${lib.getExe gnused} -i -E \
      's/version = "0-unstable-([0-9-]+)";/version = "2.1-unstable-\1";/' \
      pkgs/by-name/ti/tilem/package.nix
  '';

  meta = {
    homepage = "https://github.com/kuba160/tilem-gtk3";
    description = "Emulator and debugger for Texas Instruments Z80-based graphing calculators";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ siraben ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "tilem2";
  };
}
