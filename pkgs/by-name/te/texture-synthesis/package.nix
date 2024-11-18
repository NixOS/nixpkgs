{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "texture-synthesis";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "embarkstudios";
    repo = pname;
    rev = version;
    sha256 = "0n1wbxcnxb7x5xwakxdzq7kg1fn0c48i520j03p7wvm5x97vm5h4";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Y7Pl25be3FOn+sVSNwR9BZ0NWhRM8cPsBkhJ6rWzDKE=";

  # tests fail for unknown reasons on aarch64-darwin
  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64);

  meta = with lib; {
    description = "Example-based texture synthesis written in Rust";
    homepage = "https://github.com/embarkstudios/texture-synthesis";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "texture-synthesis";
  };
}
