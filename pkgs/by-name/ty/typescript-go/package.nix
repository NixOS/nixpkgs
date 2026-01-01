{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  nix-update-script,
}:

let
  buildGoModule = buildGo125Module;
in
buildGoModule {
  pname = "typescript-go";
<<<<<<< HEAD
  version = "0-unstable-2025-12-19";
=======
  version = "0-unstable-2025-11-24";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
<<<<<<< HEAD
    rev = "d9178cc1fef3cedc3c1a48a652e63dd83310ea20";
    hash = "sha256-W6EIyS/EpqkN45vK30qrS7dc2zMUsjkrDGzMJ4eHADE=";
    fetchSubmodules = false;
  };

  vendorHash = "sha256-1uZemqPsDxiYRVjLlC/UUP4ZXVCjocIBCj9uCzQHmog=";
=======
    rev = "bd7c18dc8ed3c5ed960d72f1e329353f0a594bcc";
    hash = "sha256-RbLplpBIf7K576T6nN8EBr2TPoPuk8O9SbZ/VMHq3aw=";
    fetchSubmodules = false;
  };

  vendorHash = "sha256-1QEwrFS4Qesp2CwzcsuMP8mLQlXKzfNaM9PFMEfDYxk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
  ];

  env.CGO_ENABLED = 0;

  subPackages = [
    "cmd/tsgo"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    version="$("$out/bin/tsgo" --version)"
    [[ "$version" == *"7.0.0"* ]]

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
  };

  meta = {
    description = "Go implementation of TypeScript";
    homepage = "https://github.com/microsoft/typescript-go";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "tsgo";
  };
}
