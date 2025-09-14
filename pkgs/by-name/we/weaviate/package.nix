{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "weaviate";
  version = "1.32.5";

  src = fetchFromGitHub {
    owner = "weaviate";
    repo = "weaviate";
    rev = "v${version}";
    hash = "sha256-LPGuYnLVIShIJeFNoNqlf9OgwtDuH/efPtWj9mAR0uQ=";
  };

  vendorHash = "sha256-CuTX2yscnZrOV+be+cx5Vr8jXfduEF4My2CEFA6IIjQ=";

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
