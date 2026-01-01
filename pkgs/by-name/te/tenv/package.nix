{
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  tenv,
  testers,
}:

buildGoModule rec {
  pname = "tenv";
<<<<<<< HEAD
  version = "4.9.0";
=======
  version = "4.8.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "tofuutils";
    repo = "tenv";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-B9K8IDUjd3gQrg5q2IoIsKJHHzRDil4oHEuB2DTMS3k=";
  };

  vendorHash = "sha256-+kJ3TMAyuHZBHfINAOsAP3XIF4TYfO9zH+8ZKJOvPK0=";
=======
    hash = "sha256-p0LaTj+hGZapvJR5IU0hwaeUjyBwEsvOXQhvA+NXHkw=";
  };

  vendorHash = "sha256-BZjS9A6j0S1Q1Aq0BeHXT8jiO4gZG4t3xySF4VtTsS4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  excludedPackages = [ "tools" ];

  # Tests disabled for requiring network access to release.hashicorp.com
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tenv \
      --zsh <($out/bin/tenv completion zsh) \
      --bash <($out/bin/tenv completion bash) \
      --fish <($out/bin/tenv completion fish)
  '';

  passthru.tests.version = testers.testVersion {
    command = "HOME=$TMPDIR tenv --version";
    package = tenv;
    version = "v${version}";
  };

  meta = {
    changelog = "https://github.com/tofuutils/tenv/releases/tag/v${version}";
    description = "OpenTofu, Terraform, Terragrunt and Atmos version manager written in Go";
    homepage = "https://tofuutils.github.io/tenv";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      rmgpinto
      nmishin
      kvendingoldo
    ];
  };
}
