{ lib
, fetchFromGitHub
, buildGoModule
, nix-update-script
, nixosTests
}:

buildGoModule rec {
  pname = "transfer-sh";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "dutchcoders";
    repo = "transfer.sh";
    rev = "v${version}";
    hash = "sha256-V8E6RwzxKB6KeGPer5074e7y6XHn3ZD24PQMwTxw5lQ=";
  };

  vendorHash = "sha256-C8ZfUIGT9HiQQiJ2hk18uwGaQzNCIKp/Jiz6ePZkgDQ=";

  passthru = {
    tests = {
      inherit (nixosTests) transfer-sh;
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Easy and fast file sharing and pastebin server with access from the command-line";
    homepage = "https://github.com/dutchcoders/transfer.sh";
    changelog = "https://github.com/dutchcoders/transfer.sh/releases";
    mainProgram = "transfer.sh";
    license = licenses.mit;
    maintainers = with maintainers; [ ocfox pinpox ];
  };
}
