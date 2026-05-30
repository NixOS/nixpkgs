{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  ffmpeg-headless,
}:

buildGoModule (finalAttrs: {
  pname = "ytarchive";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Kethsar";
    repo = "ytarchive";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Y1frd7iJJuNFvLL/C1Y+RrqYC/1LF7P3J9rkPAThp9c=";
  };

  vendorHash = "sha256-hVAiWJKdDQB+6UlARFdjVATCMiGrEK2US62KAxCquvU=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Commit=-${finalAttrs.src.rev}"
  ];

  postInstall = ''
    wrapProgram $out/bin/ytarchive --prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]}
  '';

  meta = {
    homepage = "https://github.com/Kethsar/ytarchive";
    description = "Garbage Youtube livestream downloader";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "ytarchive";
  };
})
