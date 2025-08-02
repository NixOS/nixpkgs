{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "weaviate";
  version = "1.31.6";

  src = fetchFromGitHub {
    owner = "weaviate";
    repo = "weaviate";
    rev = "v${version}";
    hash = "sha256-UuvIMmN4gyAzXB9ZXmPATOyFt7hNVh2r+c+Ho1Tn/WA=";
  };

  vendorHash = "sha256-xAP9jrkpQFoGovTL5nymG2CYxwseJ3Be3NoVVrWXDYs=";

  subPackages = [ "cmd/weaviate-server" ];

  ldflags = [
    "-w"
    "-extldflags"
    "-static"
  ];

  postInstall = ''
    ln -s $out/bin/weaviate-server $out/bin/weaviate
  '';

  meta = {
    description = "ML-first vector search engine";
    homepage = "https://github.com/semi-technologies/weaviate";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
