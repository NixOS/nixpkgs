{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "wasmi";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "wasmi";
    tag = "v${version}";
    hash = "sha256-SjoolU5R1fEbWzs9EY1CYeuPwzR5C5KkrEKCRW3wt+M=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-u2nfsWPw2kqP/Q16O3k++/el95JZacA4lVNyJ/SDKxg=";
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Efficient WebAssembly interpreter";
    homepage = "https://github.com/paritytech/wasmi";
    changelog = "https://github.com/paritytech/wasmi/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "wasmi_cli";
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
