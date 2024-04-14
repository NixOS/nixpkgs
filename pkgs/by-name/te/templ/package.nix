{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "templ";
  version = "0.2.663";

  src = fetchFromGitHub {
    owner = "a-h";
    repo = "templ";
    rev = "v${version}";
    hash = "sha256-TU8QG6OmUzSNDAX9W0Ntmz5cucLqVQeTskfnJbm/YM0=";
  };

  vendorHash = "sha256-Upd5Wq4ajsyOMDiAWS2g2iNO1sm1XJc43AFQLIo5eDM=";

  subPackages = [ "cmd/templ" ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-extldflags -static"
  ];

  meta = {
    description = "A language for writing HTML user interfaces in Go";
    homepage = "https://github.com/a-h/templ";
    license = lib.licenses.mit;
    mainProgram = "templ";
    maintainers = with lib.maintainers; [ luleyleo ];
  };
}
