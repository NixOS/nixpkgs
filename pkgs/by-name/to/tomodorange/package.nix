{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  alsa-lib,
  dbus,
  expat,
  fontconfig,
  freetype,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tomodorange";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "1dragon-xyz";
    repo = "tomodorange";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o90ltaF5J4dX918R6cX+cvCNXht32AVVwvVWUBt38jo=";
  };

  cargoHash = "sha256-1sBjtQmD9eWzGBXKea6Wa1pccwtmKTy9WcygG1NdLBY=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    libcosmicAppHook
  ];

  buildInputs = [
    alsa-lib
    dbus
    expat
    fontconfig
    freetype
  ];

  postInstall = ''
    install -Dm644 io.github._1dragon_xyz.tomodorange.desktop -t $out/share/applications
    install -Dm644 assets/icon.png $out/share/icons/hicolor/256x256/apps/io.github._1dragon_xyz.tomodorange.png
    install -Dm644 io.github._1dragon_xyz.tomodorange.metainfo.xml -t $out/share/metainfo
  '';

  meta = {
    description = "Native COSMIC™ Pomodoro timer for deep focus";
    homepage = "https://github.com/1dragon-xyz/tomodorange";
    changelog = "https://github.com/1dragon-xyz/tomodorange/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "tomodorange";
  };
})
