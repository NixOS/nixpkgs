{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
  apple-sdk_15,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yashiki";
  version = "0.15.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "typester";
    repo = "yashiki";
    tag = "yashiki-v${finalAttrs.version}";
    hash = "sha256-nsmUuhi0yy6x6POC4qLbMib4fxS3QRjlK6QgCiVEnyQ=";
  };

  cargoHash = "sha256-3JxtsSipMbMxQO58ZLJbQVrOFFC7FoVguNpqdoL+ziQ=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    apple-sdk_15
  ];

  postInstall = ''
    app="$out/Applications/Yashiki.app"

    mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources/layouts"

    ln -s "$out/bin/yashiki" "$app/Contents/MacOS/yashiki"
    ln -s "$out/bin/yashiki-layout-tatami" "$app/Contents/Resources/layouts/yashiki-layout-tatami"
    ln -s "$out/bin/yashiki-layout-byobu" "$app/Contents/Resources/layouts/yashiki-layout-byobu"

    cp resources/icon/Assets.car "$app/Contents/Resources/Assets.car"
    substitute Info.plist.template "$app/Contents/Info.plist" \
      --replace-fail VERSION_PLACEHOLDER "${finalAttrs.version}"

    installShellCompletion --cmd yashiki --zsh completions/zsh/_yashiki
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "macOS tiling window manager";
    homepage = "https://github.com/typester/yashiki";
    changelog = "https://github.com/typester/yashiki/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = with lib.maintainers; [
      anntnzrb
      Br1ght0ne
    ];
    mainProgram = "yashiki";
    platforms = lib.platforms.darwin;
  };
})
