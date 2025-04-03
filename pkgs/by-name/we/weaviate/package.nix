{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "weaviate";
  version = "1.29.1";

  src = fetchFromGitHub {
    owner = "weaviate";
    repo = "weaviate";
    rev = "v${version}";
    hash = "sha256-Akg0iY5M3X6ztKxhNEkhi03VnbNpNW7/Vcbv2KB6X54=";
  };

  vendorHash = "sha256-U2ean49ESKmcQ3fTtd6y9MwfWPr6tolvgioyKbQsBmU=";

  subPackages = [ "cmd/weaviate-server" ];

  ldflags = [
    "-w"
    "-extldflags"
    "-static"
  ];

  postInstall = ''
    ln -s $out/bin/weaviate-server $out/bin/weaviate
  '';

  meta = with lib; {
    description = "ML-first vector search engine";
    homepage = "https://github.com/semi-technologies/weaviate";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dit7ya ];
  };
}
