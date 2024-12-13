{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "terraform-ls";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fNIOFfNh96npfZ7BTTPH7V1VND4okt+UURdzS3JWHUc=";
  };

  vendorHash = "sha256-JW8qs2ZjH+S8zdEh8/da0SptooE3iTS6JqoIUh20R2Y=";

  ldflags = [
    "-s"
    "-w"
  ];

  # There's a mixture of tests that use networking and several that fail on aarch64
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/terraform-ls --help
    $out/bin/terraform-ls --version | grep "${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Terraform Language Server (official)";
    mainProgram = "terraform-ls";
    homepage = "https://github.com/hashicorp/terraform-ls";
    changelog = "https://github.com/hashicorp/terraform-ls/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [
      mbaillie
      jk
    ];
  };
}
