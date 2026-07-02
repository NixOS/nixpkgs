{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "weaviate";
  version = "1.38.2";

  src = fetchFromGitHub {
    owner = "weaviate";
    repo = "weaviate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qWb1jTC3pmyK7WZ/mw5aF3spXL130WCKglYEoJVmsO8=";
  };

  vendorHash = "sha256-+I7yxIql/ttC7zTcK870GX52LDfSbfCZvDW+eeCYnB0=";

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
