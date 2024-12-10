{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "vault-medusa";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "jonasvinther";
    repo = "medusa";
    rev = "v${version}";
    sha256 = "sha256-c5ldU54SQQKnKp2xxUiHVOaCRV9ttC24sN8AUMMuWzQ=";
  };

  vendorHash = "sha256-GdQiPeU5SWZlqWkyk8gU9yVTUQxJlurhY3l1xZXKeJY=";

  meta = with lib; {
    description = "Cli tool for importing and exporting Hashicorp Vault secrets";
    mainProgram = "medusa";
    homepage = "https://github.com/jonasvinther/medusa";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
