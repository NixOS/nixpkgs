{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "zdns";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-3ksDCl2dwRwFASRo7PSX+TDHFmn7ezhKjVA5Y0Aju+A=";
  };

  vendorHash = "sha256-OkGVf++LS30QFFaf2FSCi+64UDRR70hExyz0PjNEe6g=";

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
