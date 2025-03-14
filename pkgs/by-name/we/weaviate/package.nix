{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "weaviate";
  version = "1.28.5";

  src = fetchFromGitHub {
    owner = "weaviate";
    repo = "weaviate";
    rev = "v${version}";
    hash = "sha256-avFO+FrhTWGxt5FGEIczu+3qL29WroqJFaYfNDP1gpI=";
  };

  vendorHash = "sha256-4JM+MGrlZLCWGcOG5bAuVO/Z+VUB09pvyv/T9r6z/qo=";

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
