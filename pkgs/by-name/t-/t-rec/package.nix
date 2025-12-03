{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  imagemagick,
  libiconv,
  ffmpeg,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "t-rec";
  version = "0.7.10";

  src = fetchFromGitHub {
    owner = "sassman";
    repo = "t-rec-rs";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-FyLahDf72uNPCKYqFyWxDkWw90R4Pnq94v64iFaAYFI=";
  };

  cargoHash = "sha256-J+Ng+X1k4oMtWPKkDevQVnYuFu7Ba35X4hBg3i3p8qM=";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    imagemagick
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  postInstall = ''
    wrapProgram "$out/bin/t-rec" --prefix PATH : "${
      lib.makeBinPath [
        imagemagick
        ffmpeg
      ]
    }"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Blazingly fast terminal recorder that generates animated gif images for the web written in rust";
    homepage = "https://github.com/sassman/t-rec-rs";
    changelog = "https://github.com/sassman/t-rec-rs/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [
      hoverbear
      matthiasbeyer
    ];
    mainProgram = "t-rec";
  };
})
