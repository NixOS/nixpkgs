{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "terraform-backend-git";
<<<<<<< HEAD
  version = "0.1.9";
=======
  version = "0.1.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "plumber-cd";
    repo = "terraform-backend-git";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-hOHNUgRFb2Hh1P3W4tpB6COzTZiR59SP7luEevyozQg=";
  };

  vendorHash = "sha256-c1gf1qrxZ2rjB4GOh214vrtFBVo5nHJj5tesdiJxbjw=";
=======
    hash = "sha256-mZbGMv5b9wK/gWqQB75sDJIVURrS6t/L7WBhTonaatQ=";
  };

  vendorHash = "sha256-vFx59dIdniLRP0xHcD3c22GidZOPdGZvmvg/BvxFBGI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/plumber-cd/terraform-backend-git/cmd.Version=${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd terraform-backend-git \
      --bash <($out/bin/terraform-backend-git completion bash) \
      --fish <($out/bin/terraform-backend-git completion fish) \
      --zsh <($out/bin/terraform-backend-git completion zsh)
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Terraform HTTP Backend implementation that uses Git repository as storage";
    mainProgram = "terraform-backend-git";
    homepage = "https://github.com/plumber-cd/terraform-backend-git";
    changelog = "https://github.com/plumber-cd/terraform-backend-git/blob/${src.rev}/CHANGELOG.md";
<<<<<<< HEAD
    license = lib.licenses.asl20;
=======
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
