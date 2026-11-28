{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "toofan";
  version = "2.4.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vyrx-dev";
    repo = "toofan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c58tQhSu600MtcOJqp9XEmJdMt5GJn+tv5O3JghG0os=";
  };

  vendorHash = "sha256-YSjJ8NOL97hXZLnfGYIjoKmARv+gWOsv+5qkl9konnA=";

  ldflags = [ "-s" ];

  meta = {
    description = "A minimal, lightning-fast typing TUI for your terminal";
    homepage = "https://github.com/vyrx-dev/toofan";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gwg313 ];
    mainProgram = "toofan";
  };
})
