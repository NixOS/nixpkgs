{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "weaviate";
  version = "1.40.4";

  src = fetchFromGitHub {
    owner = "weaviate";
    repo = "weaviate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eR0NTu4rV/orawHPNHTFuulMypLq/MG4c4ByzRTCqQY=";
  };

  vendorHash = "sha256-p4/5qbqg4wYr3zzTcPJlGrcpOmEj79aayaWOpcBBiMQ=";

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
