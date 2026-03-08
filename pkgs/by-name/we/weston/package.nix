{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  python3,
  wayland-scanner,
  cairo,
  libGL,
  libdisplay-info_0_2,
  libdrm,
  libevdev,
  libinput,
  libxkbcommon,
  libgbm,
  seatd,
  wayland,
  wayland-protocols,
  libxcb-cursor,
  glslang,

  demoSupport ? true,
  jpegSupport ? true,
  libjpeg,
  lcmsSupport ? true,
  lcms2,
  luaSupport ? true,
  lua5_4_compat,
  pangoSupport ? true,
  pango,
  pipewireSupport ? true,
  pipewire,
  rdpSupport ? true,
  freerdp,
  remotingSupport ? true,
  gst_all_1,
  vaapiSupport ? false,
  libva,
  vncSupport ? true,
  aml,
  neatvnc,
  pam,
  vulkanSupport ? true,
  vulkan-headers,
  vulkan-loader,
  webpSupport ? true,
  libwebp,
  xwaylandSupport ? true,
  libxcursor,
  xwayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "weston";
  version = "15.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "wayland";
    repo = "weston";
    rev = finalAttrs.version;
    hash = "sha256-7FbQkXazsf6FkkNbE+Q6ilKACFa/CoOL2Q1oXHuaVX8=";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    wayland-scanner
  ]
  ++ lib.optional vulkanSupport glslang;

  buildInputs = [
    cairo
    libGL
    libdisplay-info_0_2
    libdrm
    libevdev
    libinput
    libxkbcommon
    libgbm
    seatd
    wayland
    wayland-protocols
  ]
  ++ lib.optional jpegSupport libjpeg
  ++ lib.optional lcmsSupport lcms2
  ++ lib.optional luaSupport lua5_4_compat
  ++ lib.optional pangoSupport pango
  ++ lib.optional pipewireSupport pipewire
  ++ lib.optional rdpSupport freerdp
  ++ lib.optionals remotingSupport [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ]
  ++ lib.optional vaapiSupport libva
  ++ lib.optionals vncSupport [
    aml
    neatvnc
    pam
  ]
  ++ lib.optionals vulkanSupport [
    vulkan-headers
    vulkan-loader
  ]
  ++ lib.optional webpSupport libwebp
  ++ lib.optionals xwaylandSupport [
    libxcursor
    libxcb-cursor
    xwayland
  ];

  mesonFlags = [
    (lib.mesonBool "deprecated-backend-drm-screencast-vaapi" vaapiSupport)
    (lib.mesonBool "backend-pipewire" pipewireSupport)
    (lib.mesonBool "backend-rdp" rdpSupport)
    (lib.mesonBool "backend-vnc" vncSupport)
    (lib.mesonBool "color-management-lcms" lcmsSupport)
    (lib.mesonBool "demo-clients" demoSupport)
    (lib.mesonBool "image-jpeg" jpegSupport)
    (lib.mesonBool "image-webp" webpSupport)
    (lib.mesonBool "pipewire" pipewireSupport)
    (lib.mesonBool "remoting" remotingSupport)
    (lib.mesonBool "renderer-vulkan" vulkanSupport)
    (lib.mesonOption "simple-clients" "")
    (lib.mesonBool "shell-lua" luaSupport)
    (lib.mesonBool "test-junit-xml" false)
    (lib.mesonBool "xwayland" xwaylandSupport)
  ]
  ++ lib.optionals xwaylandSupport [
    (lib.mesonOption "xwayland-path" (lib.getExe xwayland))
  ];

  passthru = {
    providedSessions = [ "weston" ];
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Lightweight and functional Wayland compositor";
    longDescription = ''
      Weston is the reference implementation of a Wayland compositor, as well
      as a useful environment in and of itself.
      Out of the box, Weston provides a very basic desktop, or a full-featured
      environment for non-desktop uses such as automotive, embedded, in-flight,
      industrial, kiosks, set-top boxes and TVs. It also provides a library
      allowing other projects to build their own full-featured environments on
      top of Weston's core. A small suite of example or demo clients are also
      provided.
    '';
    homepage = "https://gitlab.freedesktop.org/wayland/weston";
    license = lib.licenses.mit; # Expat version
    platforms = lib.platforms.linux;
    mainProgram = "weston";
    maintainers = with lib.maintainers; [
      qyliss
    ];
  };
})
