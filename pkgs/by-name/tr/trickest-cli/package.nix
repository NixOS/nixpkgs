{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "trickest-cli";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "trickest";
    repo = "trickest-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-wzBUPotuv1natDB896Uu+O9Nj4ycT8jkcvIumjMdbqs=";
  };

  vendorHash = "sha256-gk8YMMvTHBL7yoXU9n0jhtUS472fqLW5m+mSl4Lio6c=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "CLI tool to execute Trickest workflows";
    homepage = "https://github.com/trickest/trickest-cli";
    changelog = "https://github.com/trickest/trickest-cli/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "trickest";
  };
}
