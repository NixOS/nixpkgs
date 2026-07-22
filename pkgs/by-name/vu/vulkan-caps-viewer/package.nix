{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
  vulkan-loader,
  wayland,
  xcbuild,

  waylandSupport ? lib.meta.availableOn stdenv.hostPlatform wayland,
  x11Support ? !stdenv.hostPlatform.isDarwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vulkan-caps-viewer";
  version = "4.11";

  src = fetchFromGitHub {
    owner = "SaschaWillems";
    repo = "VulkanCapsViewer";
    tag = finalAttrs.version;
    hash = "sha256-Vc4zK1Kurirp+xK7A2D3CC4veJSghE9mS7YzRA3CnHM=";
    # Note: this derivation strictly requires vulkan-header to be the same it was developed against.
    # To help us, they've put it in a git-submodule.
    # The result will work with any vulkan-loader version.
    fetchSubmodules = true;
  };

  patches = [
    # In Qt 6.10+, the path of the Metal layer has changed.
    # Without this patch, the application fails to launch on darwin.
    # Upstream PR: https://github.com/SaschaWillems/VulkanCapsViewer/pull/270
    ./Fix-darwin-metal-layer.patch
  ];

  postPatch = ''
    # These paths are appended to the install target, so we strip the /usr/ prefix
    substituteInPlace vulkanCapsViewer.pro \
      --replace-fail '/usr/' '/' \
      --replace-fail '$(VULKAN_SDK)/lib/libvulkan.dylib' '${lib.getLib vulkan-loader}/lib/libvulkan.dylib'
  '';

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcbuild
  ];

  buildInputs = [
    vulkan-loader
  ]
  ++ lib.optionals waylandSupport [
    wayland
  ];

  qmakeFlags = [
    "CONFIG+=release"
  ]
  # The README incorrectly states that these should not be defined simultaneously.
  # Enabling both WAYLAND and X11 at the same time doesn't cause any issues
  # and is actually required to automatically fallback to the X11 surface test
  # when no Wayland display is available.
  # These two variables only control the surface presentation tests for the
  # queue families of a GPU and are not related to how the Qt application is rendered.
  ++ lib.optionals waylandSupport [
    "DEFINES+=WAYLAND"
  ]
  ++ lib.optionals x11Support [
    "DEFINES+=X11"
  ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications"
    cp -r vulkanCapsViewer.app "$out/Applications"
  '';

  meta = {
    mainProgram = "vulkanCapsViewer";
    description = "Vulkan hardware capability viewer";
    longDescription = ''
      Client application to display hardware implementation details for GPUs supporting the Vulkan API by Khronos.
      The hardware reports can be submitted to a public online database that allows comparing different devices, browsing available features, extensions, formats, etc.
    '';
    homepage = "https://vulkan.gpuinfo.org/";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      pedrohlc
      niklaskorz
    ];
    changelog = "https://github.com/SaschaWillems/VulkanCapsViewer/releases/tag/${finalAttrs.version}";
  };
})
