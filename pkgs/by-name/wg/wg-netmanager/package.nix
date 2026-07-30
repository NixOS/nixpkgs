{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wg-netmanager";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "gin66";
    repo = "wg_netmanager";
    rev = "wg_netmanager-v${finalAttrs.version}";
    sha256 = "sha256-Mr4+TW1yOePEHa7puz6mTRJ514LGQeiEwPW3NKupV/M=";
  };

  cargoHash = "sha256-LtZTfmVVUqxc9GAM6mLLmlJXBhLqnfrvBZWh0RWrR/0=";

  # Test 01 tries to create a wireguard interface, which requires sudo.
  doCheck = true;
  checkFlags = [
    "--skip"
    "device"
  ];

  meta = {
    description = "Wireguard network manager";
    longDescription = ''
      Wireguard network manager, written in rust, simplifies the setup of wireguard nodes,
      identifies short connections between nodes residing in the same subnet,
      identifies unreachable aka dead nodes and maintains the routes between all nodes automatically.
      To achieve this, wireguard network manager needs to be running on each node.
    '';
    homepage = "https://github.com/gin66/wg_netmanager";
    license = with lib.licenses; [
      mit
      asl20
      bsd3
      mpl20
    ];
    maintainers = with lib.maintainers; [ gin66 ];
    platforms = lib.platforms.linux;
    mainProgram = "wg_netmanager";
  };
})
