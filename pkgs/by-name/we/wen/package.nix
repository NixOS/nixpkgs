{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "wen";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "zachthieme";
    repo = "wen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cue+Tw5/yGID41lnyY6yFh3f3W/fjfEUltMVo7hEKjE=";
  };

  vendorHash = "sha256-PI8k21Wiy2XgecmdZVUIzEF/l4FzfTtvuJIHqoeVufU=";

  subPackages = [ "cmd/wen" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Natural language date parser and interactive terminal calendar";
    homepage = "https://github.com/zachthieme/wen";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zachthieme ];
    mainProgram = "wen";
  };
})
