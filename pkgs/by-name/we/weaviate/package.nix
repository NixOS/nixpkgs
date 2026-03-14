{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "weaviate";
  version = "1.36.5";

  src = fetchFromGitHub {
    owner = "weaviate";
    repo = "weaviate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-a248yTqPgMfdk+vj0KOJ7+iJl8euNv50wgJ1aaXNZ+I=";
  };

  vendorHash = "sha256-7ux2BshTaTubJ7SHBDKggja7hPIj1WnDAj1QWXqjwjY=";

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
})
