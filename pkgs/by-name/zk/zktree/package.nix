{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "zktree";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "alirezameskin";
    repo = "zktree";
    rev = version;
    sha256 = "11w86k1w5zryiq6bqr98pjhffd3l76377yz53qx0n76vc5374fk9";
  };

  cargoHash = "sha256-RZtxpUsh8Gt/7bNcVGE4qfiLLENHDHAYXZapNOpTZ6M=";

  meta = with lib; {
    description = "Small tool to display Znodes in Zookeeper in tree structure";
    homepage = "https://github.com/alirezameskin/zktree";
    license = licenses.unlicense;
    maintainers = with lib.maintainers; [ alirezameskin ];
    mainProgram = "zktree";
  };
}
