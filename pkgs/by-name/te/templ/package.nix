{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "templ";
  version = "0.3.960";

  src = fetchFromGitHub {
    owner = "a-h";
    repo = "templ";
    rev = "v${version}";
    hash = "sha256-GCbqaRC9KipGdGfgnGjJu04/rJlg+2lgi2vluP05EV4=";
  };

  vendorHash = "sha256-pVZjZCXT/xhBCMyZdR7kEmB9jqhTwRISFp63bQf6w5A=";

  subPackages = [ "cmd/templ" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-extldflags -static"
  ];

  meta = {
    description = "Language for writing HTML user interfaces in Go";
    homepage = "https://github.com/a-h/templ";
    license = lib.licenses.mit;
    mainProgram = "templ";
    maintainers = with lib.maintainers; [ luleyleo ];
  };
}
