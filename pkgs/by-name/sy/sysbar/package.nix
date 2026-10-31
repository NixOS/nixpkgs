{
  lib,
  stdenv,
  fetchFromGitHub,

  pkg-config,
  wayland-scanner,
  wrapGAppsHook4,

  gtkmm4,
  curl,
  gtk4-layer-shell,
  jsoncpp,
  dbus,
  wireplumber,
  playerctl,
  libnl,

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
    pkg-config
    wayland-scanner
    wrapGAppsHook4
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

  enableParallelBuilding = true;

  installFlags = [ "PREFIX=$(out)" ];

  # Use the prefixed pkg-config and query libnl through it instead of the
  # hardcoded /usr/include/libnl3.  Load libsysbar.so and the default
  # configuration from the store, and populate the version info printed by
  # `sysbar -v` since the source has no .git directory.
  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '$(shell pkg-config' '$(shell $(PKG_CONFIG)' \
      --replace-fail 'CXXFLAGS += -I /usr/include/libnl3/ -lnl-3 -lnl-genl-3' \
        'PKGS += libnl-3.0 libnl-genl-3.0'
    substituteInPlace src/main.cpp \
      --replace-fail '"libsysbar.so"' "\"$out/lib/libsysbar.so\"" \
      --replace-fail /usr/share/sys64/bar/config.conf $out/share/sys64/bar/config.conf
    substituteInPlace src/window.cpp \
      --replace-fail /usr/share/sys64/bar/style.css $out/share/sys64/bar/style.css
    substituteInPlace src/modules/clock.cpp \
      --replace-fail /usr/share/sys64/bar/calendar.conf $out/share/sys64/bar/calendar.conf

    cat > src/git_info.hpp <<EOF
    #define GIT_COMMIT_MESSAGE "${finalAttrs.src.rev}"
    #define GIT_COMMIT_DATE "${lib.removePrefix "0-unstable-" finalAttrs.version}"
    EOF
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Modular status bar for Wayland";
    homepage = "https://github.com/System64fumo/sysbar";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "sysbar";
    platforms = lib.platforms.linux;
  };
})
