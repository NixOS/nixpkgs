{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "weaviate";
  version = "1.33.11";

  src = fetchFromGitHub {
    owner = "weaviate";
    repo = "weaviate";
    rev = "v${version}";
    hash = "sha256-v7RnWb3Lg++AasNY2LzvMRfatDzPecrV47gScep6opY=";
  };

  vendorHash = "sha256-JG8UwPGij3F2zCMVNgPiRyPegL0aIsWy4rchKmWaAro=";

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
    homepage = "https://github.com/weaviate/weaviate";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
