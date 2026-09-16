{
  lib,
  stdenv,
  autoPatchelfHook,
  alsa-lib,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  dpkg,
  expat,
  fetchurl,
  glib,
  gtk3,
  libGL,
  libdrm,
  libgbm,
  libnotify,
  libsecret,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  libxscrnsaver,
  libxtst,
  makeWrapper,
  nspr,
  nss,
  pango,
  systemd,
  util-linux,
  vulkan-loader,
  writableTmpDirAsHomeHook,
  xdg-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zcode";
  version = "3.10.1";

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://cdn-zcode.z.ai/zcode/electron/releases/${finalAttrs.version}/linux-x64/ZCode-${finalAttrs.version}-linux-x64.deb";
        hash = "sha256-HezuwB4FRaTH+OJlFiabHoRd/DUkWYsWVeOLxhrL8Is=";
      };
      aarch64-linux = fetchurl {
        url = "https://cdn-zcode.z.ai/zcode/electron/releases/${finalAttrs.version}/linux-arm64/ZCode-${finalAttrs.version}-linux-arm64.deb";
        hash = "sha256-Irebq+OwD7b7/PfcwDO3VkpzT1PfTyiZjBhVYHEoayw=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    alsa-lib
    at-spi2-core
    cairo
    cups
    dbus
    expat
    gtk3
    glib
    libGL
    libdrm
    libgbm
    libnotify
    libsecret
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxscrnsaver
    libxtst
    nspr
    nss
    pango
  ];

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  runtimeDependencies = [
    libGL
    systemd
  ];

  doInstallCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin
    mv opt/ZCode $out/lib/zcode
    mv usr/share $out/share

    # dlopen()ed by ANGLE at runtime, so autoPatchelfHook's RUNPATH doesn't
    # cover them; without this the GPU process falls back to software rendering.
    makeWrapper $out/lib/zcode/zcode $out/bin/zcode \
      --prefix PATH : ${
        lib.makeBinPath [
          util-linux
          xdg-utils
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libGL
          vulkan-loader
        ]
      } \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-wayland-ime=true --wayland-text-input-version=3}}"

    substituteInPlace $out/share/applications/zcode.desktop \
      --replace-fail 'Exec=/opt/ZCode/zcode' 'Exec=zcode'

    install -d $out/share/licenses/zcode
    ln -s $out/lib/zcode/LICENSE.electron.txt $out/share/licenses/zcode/LICENSE.electron.txt
    ln -s $out/lib/zcode/LICENSES.chromium.html $out/share/licenses/zcode/LICENSES.chromium.html

    runHook postInstall
  '';

  meta = {
    description = "Desktop application for AI-assisted software development";
    homepage = "https://zcode.z.ai";
    changelog = "https://zcode.z.ai/en/changelog";
    downloadPage = "https://zcode.z.ai/en";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ LingLambda ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "zcode";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
