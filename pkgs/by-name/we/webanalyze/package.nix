{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "webanalyze";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "rverton";
    repo = "webanalyze";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XJ3GFJ+Y0PzbW91fz50AFePlrKpIarovm20/bpD8JPg=";
  };

  vendorHash = "sha256-3ibtsP4rsG3+i1JTNtiQlaL146Q+wxGQfWgZDroibSw=";

  meta = {
    description = "Tool to uncover technologies used on websites";
    homepage = "https://github.com/rverton/webanalyze";
    changelog = "https://github.com/rverton/webanalyze/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "webanalyze";
  };
})
