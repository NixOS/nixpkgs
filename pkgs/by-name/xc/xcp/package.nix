{
  rustPlatform,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xcp";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = "xcp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tAECD3gNx6RDzEJhGt2nrykxHfh4S1qJKt9yNdZpuGs=";
  };

  # no such file or directory errors
  doCheck = false;

  useFetchCargoVendor = true;
  cargoHash = "sha256-plWq+p6NqOjonkdsGAL7hHBwVzFtkkgTNWNKEOBNZeU=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ lom ];
    mainProgram = "xcp";
  };
})
