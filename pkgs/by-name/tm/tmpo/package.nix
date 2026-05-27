{
  lib,
  fetchFromGitHub,
  buildGoModule,
  ...
}:
{
  tmpo = buildGoModule rec {
    pname = "tmpo";
    version = "0.8.1";

    src = fetchFromGitHub {
      owner = "DylanDevelops";
      repo = "tmpo";
      rev = "v0.8.1";
      hash = "sha256-dnHvkTFX6SAMnyLewgYDj3a4EwKAQp7B8j0Mxuyy37E=";
    };
    proxyVendor = true;
    vendorHash = "sha256-mj9gRkFiNyQDlp8U9G27uRENvulmuZhnHuIDc3FESvA=";

    checkFlags = [
      "-skip=TestIsInGitRepo" # fetchFromGithub does not include a .git folder.
    ];

    meta = with lib; {
      description = "A minimal CLI time tracker for developers.";
      homepage = "https://github.com/DylanDevelops/tmpo?tab=readme-ov-file";
      license = licenses.mit;
      mainProgram = "tmpo";
      platforms = platforms.linux;
      maintainers = with maintainers; [ kggx ];
    };
  };

}
