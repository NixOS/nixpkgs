{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  makeBinaryWrapper,
  nix-update-script,
  stdenv,
  versionCheckHook,
  wl-clipboard,
}:

buildGoModule (finalAttrs: {
  pname = "termpicker";
  version = "1.5.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ChausseBenjamin";
    repo = "termpicker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tUmd+GotimE8CrL6sJG7+uREnZAUsd2fEkH31575hFc=";
  };

  vendorHash = "sha256-M5YZaJdv9D8NkwD+T8tAtGH5P4IKcgjqpUoKVfLo+C0=";

  excludedPackages = [ "internal/documentation" ];

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  postInstall =
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      go run ./internal/documentation
      installManPage termpicker.1
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
        --prefix PATH : ${lib.makeBinPath [ wl-clipboard ]}
    '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Color picker for the terminal";
    homepage = "https://github.com/ChausseBenjamin/termpicker";
    changelog = "https://github.com/ChausseBenjamin/termpicker/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.beerware;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "termpicker";
  };
})
