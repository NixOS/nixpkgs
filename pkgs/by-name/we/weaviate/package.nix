{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "weaviate";
  version = "1.40.7";

  src = fetchFromGitHub {
    owner = "weaviate";
    repo = "weaviate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xt1GtG9Nc/ddHxnUfg5aZvycL73YnoRAhX7dHxwmHbc=";
  };

  vendorHash = "sha256-Wu5u+DZtRMB0YFf3F5n7Aj23+ct2bAo8A031SSVWbFQ=";

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
