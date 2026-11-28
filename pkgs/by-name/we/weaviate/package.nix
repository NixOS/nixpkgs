{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "weaviate";
  version = "1.41.0";

  src = fetchFromGitHub {
    owner = "weaviate";
    repo = "weaviate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lEInQfp9h5ndWvXJVj4BSmlDRvTf2/Li/bY2JU/nX8E=";
  };

  vendorHash = "sha256-jfEiEkMu+v+cWxUwqfTpxtqEQB4kzLhrSh1DVny58rY=";

  subPackages = [ "cmd/weaviate-server" ];

  ldflags = [
    "-w"
    "-extldflags"
    "-static"
  ];

  postInstall = ''
    ln -s $out/bin/weaviate-server $out/bin/weaviate
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ML-first vector search engine";
    homepage = "https://github.com/weaviate/weaviate";
    changelog = "https://github.com/weaviate/weaviate/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kamadorueda ];
    mainProgram = "weaviate";
  };
})
