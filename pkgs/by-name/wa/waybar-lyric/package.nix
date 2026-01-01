{
<<<<<<< HEAD
  stdenv,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
<<<<<<< HEAD
  installShellFiles,
}:
buildGoModule (finalAttrs: {
  pname = "waybar-lyric";
  version = "0.14.3";
=======
}:
buildGoModule (finalAttrs: {
  pname = "waybar-lyric";
  version = "0.12.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Nadim147c";
    repo = "waybar-lyric";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-bpc0AF/PcdmkVr791uT2PxgV59wTAAtFMFtKHKwtkQI=";
  };

  vendorHash = "sha256-TeAZDSiww9/v3uQl8THJZdN/Ffp+FsZ3TsRStE3ndKA=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd waybar-lyric \
      --bash <($out/bin/waybar-lyric _carapace bash) \
      --fish <($out/bin/waybar-lyric _carapace fish) \
      --zsh <($out/bin/waybar-lyric _carapace zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
=======
    hash = "sha256-2iuMlcKDnhRc3PZNMjhkHElEyVdx8+p+ONHn8lC4dQ0=";
  };

  vendorHash = "sha256-JpAlpTHPxPWHBCeegnUVYsM9LjUCuvfFd0JjQpCccaM=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  versionCheckKeepEnvironment = [ "XDG_CACHE_HOME" ];
  preInstallCheck = ''
    # ERROR Failed to find cache directory
    export XDG_CACHE_HOME=$(mktemp -d)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Waybar module for displaying song lyrics";
    homepage = "https://github.com/Nadim147c/waybar-lyric";
    license = lib.licenses.agpl3Only;
    mainProgram = "waybar-lyric";
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
      Nadim147c
      vanadium5000
    ];
=======
    maintainers = with lib.maintainers; [ vanadium5000 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = lib.platforms.linux;
  };
})
