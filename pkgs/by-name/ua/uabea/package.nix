{
  lib,
  stdenv,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  wrapGAppsHook3,
  gnumake,
  gtk3,
  fontconfig,
  libice,
  libsm,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "uabea";
  version = "8";

  src = fetchFromGitHub {
    owner = "nesrak1";
    repo = "UABEA";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h132kbX2S9fySE7p1n/nixaq8mqoP+aQxYsjUt1Qu9w=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  patches = [
    ./config-directory.patch
    ./security-dependencies.patch
  ];

  postPatch = ''
    # .NET 6 is unsupported; build and run using .NET 10 instead.
    substituteInPlace */*.csproj --replace-fail net6.0 net10.0
  '';

  preConfigure = ''
    # The native texture wrapper is built with make on Linux; the standalone
    # texture preview application is only used for upstream development.
    dotnet sln UABEAvalonia.sln remove \
      TexToolWrap/TexToolWrap.vcxproj \
      TexturePluginPreview/TexturePluginPreview.csproj
  '';

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  projectFile = "UABEAvalonia.sln";
  nugetDeps = ./deps.json;
  executables = [ "UABEAvalonia" ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    gnumake
    stdenv.cc
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDeps = [
    fontconfig
    gtk3
    libice
    libsm
    libx11
    libxcursor
    libxi
    libxrandr
  ];

  # The apphost and NuGet libraries are already patched by the .NET hooks.
  dontAutoPatchelf = true;

  postFixup = ''
    autoPatchelf "$out/lib/uabea/"*.so
  '';

  postInstall = ''
    # Publishing the solution puts the plugin assemblies beside the executable.
    mkdir -p "$out/lib/uabea/plugins"
    mv "$out/lib/uabea/"{AudioClipPlugin,Fmod5Sharp,FontPlugin,NAudio.Core,OggVorbisEncoder,TextAssetPlugin,TexturePlugin}.dll \
      "$out/lib/uabea/plugins/"

    # These are copied into the main project's build directory by upstream's
    # MSBuild targets, but are not included in dotnet publish's output.
    install -m644 ReleaseFiles/* "$out/lib/uabea/"
    install -m755 TexToolWrap/libtextoolwrap.so \
      TexToolWrap/PVRTexLib/Linux_x86_64/libPVRTexLib.so \
      TexToolWrap/ispc/linux64/libispc_texcomp.so \
      TexToolWrap/crunch/linux64/libcrnlib.so \
      "$out/lib/uabea/"

    for size in 16 24 32 64; do
      install -Dm644 "UABEAvalonia/Assets/uabeavalonia$size.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/uabea.png"
    done
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "uabea";
      desktopName = "UABEA";
      comment = finalAttrs.meta.description;
      exec = "UABEAvalonia";
      icon = "uabea";
      categories = [ "Development" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unity asset bundle and serialized file reader and writer";
    homepage = "https://github.com/nesrak1/UABEA";
    changelog = "https://github.com/nesrak1/UABEA/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      asl20 # ImageSharp, used in an open-source application
      unfreeRedistributable # Bundled PVRTexLib
    ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    mainProgram = "UABEAvalonia";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # Bundled AssetsTools.NET assemblies and NuGet dependencies
      binaryNativeCode # Texture encoders and NuGet dependencies
    ];
  };
})
