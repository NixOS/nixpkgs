{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "templ";
  version = "0.2.793";

  src = fetchFromGitHub {
    owner = "a-h";
    repo = "templ";
    rev = "v${version}";
    hash = "sha256-0KGht5IMbJV8KkXgT5qJxA9bcmWevzXXAVPMQTm0ccw=";
  };

  vendorHash = "sha256-ZWY19f11+UI18jeHYIEZjdb9Ii74mD6w+dYRLPkdfBU=";

  subPackages = [ "cmd/templ" ];

  CGO_ENABLED = 0;

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
