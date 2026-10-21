{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "toofan";
  version = "2.4.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vyrx-dev";
    repo = "toofan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-koYZKGDYI+8JN5fEvBWYbHefGm/oxv61Rw04M/XxoaY=";
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
