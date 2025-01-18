{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  testers,
  treegen,
}:

buildGoModule rec {
  pname = "treegen";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bilbilak";
    repo = "treegen";
    tag = "v${version}";
    hash = "sha256-PPWUEfX7OXKZnghiVXU+eCjveA1VszA3uS8C3uI3pFM=";
  };

  vendorHash = "sha256-hocnLCzWN8srQcO3BMNkd2lt0m54Qe7sqAhUxVZlz1k=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/bilbilak/treegen/config.Version=${version}"
  ];

  passthru = {
    tests = {
      version = testers.testVersion {
        package = treegen;
        command = "treegen --version";
      };
    };

    updateScript = nix-update-script { };
  };

  meta = with lib; {
    changelog = "https://github.com/bilbilak/treegen/blob/main/CHANGELOG.md";
    description = "ASCII Tree Directory and File Structure Generator";
    homepage = "https://github.com/bilbilak/treegen";
    license = licenses.gpl3Only;
    mainProgram = "treegen";
    maintainers = with maintainers; [ _4r7if3x ];
    platforms = with platforms; unix ++ windows;
  };
}
