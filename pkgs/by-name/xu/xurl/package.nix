{
  lib,
  stdenv,
  buildPackages,
  buildGoModule,
  fetchFromGitHub,
  callPackage,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  chat-xdk = callPackage ./chat-xdk.nix { };
in
buildGoModule (finalAttrs: {
  pname = "xurl";
  version = "1.3.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "xdevplatform";
    repo = "xurl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N7I+qgdsLtHd30PiEc39iY9jjJd2LuRpVH5UUF8LH1A=";
  };

  vendorHash = "sha256-3yUZZYHcDpCaK55uiVw4X9mxvda9iL+XwPpSXheKOSc=";

  # Link the XChat bindings against the library built from source.
  modPostBuild = ''
    rm -rf vendor/github.com/xdevplatform/chat-xdk/go/chatxdk/libs
  '';

  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  buildInputs = [ chat-xdk ];

  env = {
    CGO_ENABLED = 1;
    # Avoid retaining unused libraries requested by CGO.
    NIX_LDFLAGS_BEFORE = lib.optionalString stdenv.hostPlatform.isLinux "--as-needed";
  };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/xdevplatform/xurl/version.Version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    # Upstream tests expect the development version in the User-Agent.
    unset ldflags
  '';

  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$GOPATH/bin/${finalAttrs.meta.mainProgram}"
        else
          lib.getExe buildPackages.xurl;
    in
    ''
      installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
        --bash <(${exe} completion bash) \
        --fish <(${exe} completion fish) \
        --zsh <(${exe} completion zsh)
    '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckKeepEnvironment = [ "HOME" ];

  meta = {
    description = "A curl-like CLI Tool for the X API";
    homepage = "https://github.com/xdevplatform/xurl";
    changelog = "https://github.com/xdevplatform/xurl/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tensor5 ];
    mainProgram = "xurl";
  };
})
