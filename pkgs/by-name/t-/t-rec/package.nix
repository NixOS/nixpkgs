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
<<<<<<< HEAD
  version = "0.8.2";
=======
  version = "0.7.10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "sassman";
    repo = "t-rec-rs";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    sha256 = "sha256-61wK2rtW6+C0SwrM8UJuMPe7WAkPGd6PrKt0KB52v7I=";
  };

  cargoHash = "sha256-RcEWQLH170ycqwQVdbkzX/RrVTTMtc3mCg3/6cy8IH0=";
=======
    sha256 = "sha256-FyLahDf72uNPCKYqFyWxDkWw90R4Pnq94v64iFaAYFI=";
  };

  cargoHash = "sha256-J+Ng+X1k4oMtWPKkDevQVnYuFu7Ba35X4hBg3i3p8qM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
