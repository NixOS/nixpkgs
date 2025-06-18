{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "webanalyze";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "rverton";
    repo = "webanalyze";
    tag = "v${version}";
    hash = "sha256-rnNbEPlbye0gjUamwq1xjFM/4g0eEHsGOAZWziEqxwM=";
  };

  vendorHash = "sha256-XPOsC+HoLytgv1fhAaO5HYSvuOP6OhjLyOYTfiD64QI=";

  meta = {
    description = "Tool to uncover technologies used on websites";
    homepage = "https://github.com/rverton/webanalyze";
    changelog = "https://github.com/rverton/webanalyze/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "webanalyze";
  };
}
