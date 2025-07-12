{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "zdns";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = "zdns";
    tag = "v${version}";
    hash = "sha256-jnrewp0wXaRFVBY6Wo9JHGDnDxzQFOhh3JoLqxRicew=";
  };

  vendorHash = "sha256-Uosa4Am5IQ9653TDZCOA9AS97pyQ1H2wRhXyJBQ1Eys=";

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
