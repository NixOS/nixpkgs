{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  lib,
  nix-update-script,
  copyDesktopItems,
  makeDesktopItem,
  icoutils,

  ffmpeg,
  yt-dlp,
  deno,
}:
buildDotnetModule (finalAttrs: {
  pname = "vrcvideocacher";
  version = "2026.4.4";

  src = fetchFromGitHub {
    owner = "EllyVR";
    repo = "VRCVideoCacher";
    tag = finalAttrs.version;
    hash = "sha256-VollU7um18HYeIyXC8PzqcNbBYM3gd2JzxSql4VSFWw=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  projectFile = "VRCVideoCacher/VRCVideoCacher.csproj";
  nugetDeps = ./deps.json;

  executables = [ "VRCVideoCacher" ];
  selfContainedBuild = true;

  nativeBuildInputs = [
    copyDesktopItems
    icoutils
  ];

  makeWrapperArgs = [
    "--add-flags"
    "--global-path"

    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      ffmpeg
      yt-dlp
      deno
    ])
  ];
  postInstall = ''
    icotool --icon -x $src/VRCVideoCacher/Assets/icon.ico

    for i in 16 32 48 64 128 256; do
      size=''${i}x''${i}
      install -Dm444 *_''${size}x*.png $out/share/icons/hicolor/$size/apps/vrcvideocacher.png
    done
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "vrcvideocacher";
      desktopName = "VRCVideoCacher";
      exec = finalAttrs.meta.mainProgram;
      comment = finalAttrs.meta.description;
      icon = "vrcvideocacher";
      categories = [ "Utility" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cache VRChat videos locally and fix YouTube videos that fail to load";
    homepage = "https://github.com/EllyVR/VRCVideoCacher";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ coolGi ];
    mainProgram = "VRCVideoCacher";
    platforms = [ "x86_64-linux" ];
  };
})
