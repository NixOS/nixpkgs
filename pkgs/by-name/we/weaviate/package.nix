{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "weaviate";
  version = "1.31.4";

  src = fetchFromGitHub {
    owner = "weaviate";
    repo = "weaviate";
    rev = "v${version}";
    hash = "sha256-DarJN5fbeuhAc1hFAGJR+aqgSWjMblqcj+rMyOdjMKQ=";
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

  meta = with lib; {
    description = "ML-first vector search engine";
    homepage = "https://github.com/semi-technologies/weaviate";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dit7ya ];
  };
}
