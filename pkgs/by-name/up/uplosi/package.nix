{ lib
, fetchFromGitHub
, buildGoModule
, installShellFiles
}:
buildGoModule rec {
  pname = "uplosi";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "edgelesssys";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TrHREV/bmrjwlE4bsXZDKvIQKa68AnUSktnqCKdvOe8=";
  };

  vendorHash = "sha256-0uQBhNRP3OGn3hw6Mx6tRliTqIhoBnyfRmdtdtuYwaY=";

  CGO_ENABLED = "0";
  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd uplosi \
      --bash <($out/bin/uplosi completion bash) \
      --fish <($out/bin/uplosi completion fish) \
      --zsh <($out/bin/uplosi completion zsh)
  '';

  meta = with lib; {
    description = "Upload OS images to cloud provider";
    homepage = "https://github.com/edgelesssys/uplosi";
    changelog = "https://github.com/edgelesssys/uplosi/releases/tag/v${version}";
    license = licenses.asl20;
    mainProgram = "uplosi";
    maintainers = with maintainers; [ katexochen malt3 ];
    platforms = platforms.unix;
  };
}
