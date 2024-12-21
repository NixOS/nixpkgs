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
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-rnNbEPlbye0gjUamwq1xjFM/4g0eEHsGOAZWziEqxwM=";
  };

  vendorHash = "sha256-XPOsC+HoLytgv1fhAaO5HYSvuOP6OhjLyOYTfiD64QI=";

  meta = with lib; {
    description = "Tool to uncover technologies used on websites";
    homepage = "https://github.com/rverton/webanalyze";
    changelog = "https://github.com/rverton/webanalyze/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "webanalyze";
  };
}
