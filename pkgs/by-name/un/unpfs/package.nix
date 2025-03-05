{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "unpfs";
  version = "unstable-2021-04-23";

  src = fetchFromGitHub {
    owner = "pfpacket";
    repo = "rust-9p";
    rev = "6d9b62aa182c5764e00b96f93109feb605d9eac9";
    sha256 = "sha256-zyDkUb+bFsVnxAE4UODbnRtDim7gqUNuY22vuxMsLZM=";
  };

  sourceRoot = "${src.name}/example/unpfs";

  cargoHash = "sha256-v8hbxKuxux0oYglEIK5dM9q0oBQzjyYDP1JB1cYR/T0=";

  RUSTC_BOOTSTRAP = 1;

  postInstall = ''
    install -D -m 0444 ../../README* -t "$out/share/doc/${pname}"
    install -D -m 0444 ../../LICEN* -t "$out/share/doc/${pname}"
  '';

  meta = with lib; {
    description = "9P2000.L server implementation in Rust";
    homepage = "https://github.com/pfpacket/rust-9p";
    license = licenses.bsd3;
    maintainers = with maintainers; [ raskin ];

    # macOS build fails: https://github.com/pfpacket/rust-9p/issues/7
    platforms = with platforms; linux;
    mainProgram = "unpfs";
  };
}
