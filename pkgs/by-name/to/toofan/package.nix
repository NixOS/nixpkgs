{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "toofan";
  version = "2.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vyrx-dev";
    repo = "toofan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pm3q6Fb/lUl49PsxQd7+0R9iFNQbDH05fn7O4pYAWi0=";
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
