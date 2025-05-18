{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "walk";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "walk";
    rev = "v${version}";
    hash = "sha256-yvycd+Ob/C2MRR7k7Ip9xySnsXUg/znMr6+ocIN4WKU=";
  };

  vendorHash = "sha256-a66vA6eFzckxBpVtHaX0PBtulTBPbh7c6HY3dIZAym8=";

  meta = with lib; {
    description = "Terminal file manager";
    homepage = "https://github.com/antonmedv/walk";
    license = licenses.mit;
    maintainers = with maintainers; [
      portothree
      surfaceflinger
    ];
    mainProgram = "walk";
  };
}
