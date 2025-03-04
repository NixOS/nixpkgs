{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "zdns";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-ypjUJbTQ0ntLXNRiA96BqDn/SgcbjVe9dd9zmmSqAic=";
  };

  vendorHash = "sha256-Q7W+G/yA/EvHqvDUl3T5BoP+K5ZTcLFLSaWw4TPMH2U=";

  preCheck = ''
    # Tests require network access
    substituteInPlace src/cli/worker_manager_test.go \
      --replace-fail "TestConvertNameServerStringToNameServer" "SkipTestConvertNameServerStringToNameServer"
  '';

  meta = {
    description = "CLI DNS lookup tool";
    mainProgram = "zdns";
    homepage = "https://github.com/zmap/zdns";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
