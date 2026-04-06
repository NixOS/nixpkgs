{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "tick";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "zachthieme";
    repo = "tick";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dnAsyGjVcLjmSe0Go1mJWhzuSpMnq8tUYmfXiOdRVOQ=";
  };

  vendorHash = "sha256-3AGoHAxfwXaano2hYf0wa/VoYQmjZuRnpCr6QXTILMc=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  meta = {
    description = "Terminal dashboard showing nightly host upgrade quota to hit a deadline";
    homepage = "https://github.com/zachthieme/tick";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "tick";
  };
})
