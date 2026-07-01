{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "weaviate";
  version = "1.38.0";

  src = fetchFromGitHub {
    owner = "weaviate";
    repo = "weaviate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dYApKcDW8Cs/T3uszohy0PQqKar9lkiNBMY0mnPr5xs=";
  };

  vendorHash = "sha256-1uOPet4HywajcPbZuT2ePRUrcT9mwNx0n2vFUkxUn6s=";

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
