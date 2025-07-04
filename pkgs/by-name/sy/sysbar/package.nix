{
  lib,
  stdenv,
  fetchFromGitHub,

  makeWrapper,
  pkg-config,

  gtkmm4,
  curl,
  gtk4-layer-shell,
  jsoncpp,
  dbus,
  wireplumber,
  playerctl,
  libnl,
  wayland-scanner,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sysbar";
  version = "0-unstable-2026-08-12";

  src = fetchFromGitHub {
    owner = "System64fumo";
    repo = "sysbar";
    rev = "03534d3c17f1711b48d80e6b51d9201959f17d4e";
    hash = "sha256-eJ83dzLcbqfJV5+jskSXmy0b0ESk1vJ1lSzMJ/w/kss=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    gtkmm4
    curl
    gtk4-layer-shell
    jsoncpp
    dbus
    wireplumber
    playerctl
    libnl
  ];

  env.NIX_CFLAGS_COMPILE = "-I${libnl.dev}/include/libnl3";

  enableParallelBuilding = true;

  installFlags = [ "PREFIX=$(out)" ];

  # Fix hardcoded /usr dir
  postPatch = ''
    for file in $(find . -name '*.cpp'); do
      substituteInPlace $file \
        --replace '"/usr/' "\"$out/"
    done
  '';

  # Wrap the sysbar binary to include its own lib directory in
  # LD_LIBRARY_PATH.  Please see:
  # https://github.com/System64fumo/sysbar/issues/6
  postInstall = ''
    wrapProgram $out/bin/sysbar \
      --prefix LD_LIBRARY_PATH : "$out/lib:${lib.makeLibraryPath finalAttrs.buildInputs}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modular status bar for wayland";
    homepage = "https://github.com/System64fumo/sysbar";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "sysbar";
    platforms = lib.platforms.linux;
  };
})
