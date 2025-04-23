{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "zdns";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-ZwZCDiZ4rZ8ODaEd/81muMT+OvOe59hRcNi9iZKqdFs=";
  };

  vendorHash = "sha256-f5qboa7AIAG67Yla5sPr7r1HgW8n16SnbIOuGy7JjWs=";

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
