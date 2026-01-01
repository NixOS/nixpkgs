{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "wasmi";
  version = "0.51.2";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "wasmi";
    tag = "v${version}";
    hash = "sha256-yElqCVMPB2wiCxdOzmalD2SydcBgTl0+L52MDpluWTM=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-0YxKaA7viWiQYtPXAdWXSWa79EY2x//3WiSjZ1NkkOQ=";
  passthru.updateScript = nix-update-script { };

<<<<<<< HEAD
  meta = {
    description = "Efficient WebAssembly interpreter";
    homepage = "https://github.com/paritytech/wasmi";
    changelog = "https://github.com/paritytech/wasmi/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Efficient WebAssembly interpreter";
    homepage = "https://github.com/paritytech/wasmi";
    changelog = "https://github.com/paritytech/wasmi/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      asl20
      mit
    ];
    mainProgram = "wasmi_cli";
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ dit7ya ];
=======
    maintainers = with maintainers; [ dit7ya ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
