{ lib
, fetchFromGitHub
, gitUpdater
, gtk-layer-shell
, gtk3
, libxkbcommon
, meson
, ninja
, pkg-config
, scdoc
, stdenv
, wayland
, wayland-protocols
# gtk-layer-shell fails to cross-compile due to a hard dependency
# on gobject-introspection.
# Disable it when cross-compiling since it's an optional dependency.
# This disables transparency support.
, withGtkLayerShell ? (stdenv.buildPlatform == stdenv.hostPlatform)
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wlogout";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "ArtsyMacaw";
    repo = "wlogout";
    rev = finalAttrs.version;
    hash = "sha256-n8r+E6GXXjyDYBTOMiv5musamaUFSpRTM2qHgb047og=";
  };

  outputs = [ "out" "man" ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    gtk3
    libxkbcommon
    wayland
    wayland-protocols
  ] ++ lib.optionals withGtkLayerShell [
    gtk-layer-shell
  ];

  strictDeps = true;

  mesonFlags = [
    "--datadir=${placeholder "out"}/share"
    "--sysconfdir=${placeholder "out"}/etc"
  ];

  postPatch = ''
    substituteInPlace style.css \
      --replace "/usr/share/wlogout" "$out/share/wlogout"

    substituteInPlace main.c \
      --replace "/etc/wlogout" "$out/etc/wlogout"

    # aarch64 build (cross-compilation) fails with -Werror like this:
    # aarch64-unknown-linux-gnu-gcc ... -D_FILE_OFFSET_BITS=64 -Wall -Winvalid-pch -Werror -std=c11 -Wno-unused-parameter -Wno-unused-result -Wno-missing-braces -MD -MQ wlogout.p/main.c.o -MF wlogout.p/main.c.o.d -o wlogout.p/main.c.o -c ../main.c
    # ../main.c: In function 'set_fullscreen':
    # ../main.c:499:17: error: unused variable 'mon' [-Werror=unused-variable]
    # 499 |     GdkMonitor *mon = gdk_display_get_monitor(gdk_display_get_default(), monitor);
    #     |                 ^~~
    # cc1: all warnings being treated as errors
    substituteInPlace meson.build \
      --replace-warn "werror=true" "werror=false"
  '';

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    homepage = "https://github.com/ArtsyMacaw/wlogout";
    description = "A wayland based logout menu";
    changelog = "https://github.com/ArtsyMacaw/wlogout/releases/tag/${finalAttrs.src.rev}";
    license = with lib.licenses; [ mit ];
    mainProgram = "wlogout";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (wayland.meta) platforms;
  };
})
