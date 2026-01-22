{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "zdns";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = "zdns";
    tag = "v${version}";
    hash = "sha256-e01+TjJETpWNrdtG+lHHGmS9ZS9RijOo5wRnEv6w5jk=";
  };

  vendorHash = "sha256-YlSm4uMDw5I/R4VRpoo5+t/zTwY7J62faodwKlrfbTs=";

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
