{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "understackctl";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "rackerlabs";
    repo = "understack";
    rev = "understackctl/v${version}";
    hash = "sha256-AFOTVYcZntQlgX94yrbTW26jcnRv+KT6y1FWRcMDm9g=";
  };

  sourceRoot = "${src.name}/go/understackctl";

  vendorHash = "sha256-1mmt0sDzHuOyizZELRiP/KmSXuH3CNDLJpdLZ/kqqt0=";

  # Tests require network access
  doCheck = false;

  meta = {
    description = "CLI tool for managing UnderStack deployments";
    homepage = "https://github.com/rackerlabs/understack";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ skrobul ];
    mainProgram = "understackctl";
  };
}
