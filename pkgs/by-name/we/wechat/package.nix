{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  replaceVars,

  # native
  _7zz,
  autoPatchelfHook,
  dpkg,
  makeShellWrapper,
  wrapGAppsHook3,

  # runtime
  alsa-lib,
  at-spi2-core,
  bzip2,
  cairo,
  coreutils,
  cups,
  dbus,
  expat,
  fontconfig,
  gawk,
  glib,
  gtk3,
  libredirect,
  libice,
  libsm,
  libx11,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libglvnd,
  libjack2,
  libpulseaudio,
  libxcb,
  libxcb-keysyms,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  pango,
  pipewire,
  systemd,
  util-linuxMinimal,
  wayland,
  xkeyboard-config,
  xrdb,
  zlib,
}@args:
let
  pname = "wechat";

  passthru = finalAttrs: {
    sources = lib.importJSON ./sources.json;
    updateScript = ./update.py;
    source =
      finalAttrs.passthru.sources.${stdenvNoCC.hostPlatform.system}
        or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
  };

  meta = finalAttrs: {
    description = "Messaging and calling app";
    homepage = "https://www.wechat.com/en/";
    downloadPage = "https://linux.weixin.qq.com/en";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [
      larry0x
      moraxyc
      prince213
    ];
    mainProgram = "wechat";
    platforms = lib.attrNames finalAttrs.passthru.sources;
  };

  args' = args // {
    inherit pname passthru meta;
  };
in
if stdenvNoCC.hostPlatform.isDarwin then import ./darwin.nix args' else import ./linux.nix args'
