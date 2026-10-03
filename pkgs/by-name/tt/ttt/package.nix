{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  gitMinimal,
  ripgrep,
}:

buildGoModule (finalAttrs: {
  pname = "ttt";
  version = "1.6.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "eugenioenko";
    repo = "ttt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9ZtU93DZrojVzN2ry+sBkzFQfj3v2B8is1nKVkbhUvU=";
  };

  vendorHash = "sha256-Kv/ztb2C2aj699EOC08AI09q3S+Bz6tGh9LeDlQhrac=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/ttt" ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
      --prefix PATH : ${
        lib.makeBinPath [
          gitMinimal
          ripgrep
        ]
      }
  '';

  meta = {
    description = "Terminal Text Tool: The IDE that lives in your terminal";
    homepage = "http://tttedit.dev";
    downloadPage = "https://github.com/eugenioenko/ttt";
    changelog = "https://github.com/eugenioenko/ttt/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "ttt";
  };
})
