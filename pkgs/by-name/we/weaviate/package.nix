{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "weaviate";
  version = "1.39.9";

  src = fetchFromGitHub {
    owner = "weaviate";
    repo = "weaviate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N9L8cku5uVlB5FcUQBrXwXNcTvdA8v6cYB0Nkr/4eRM=";
  };

  vendorHash = "sha256-XnYnB2FEpbqVYz7lXRufTSPW3ny/QTOYsytFoAyFPHo=";

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
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
