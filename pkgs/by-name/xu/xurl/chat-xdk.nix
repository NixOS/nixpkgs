{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

let
  juicebox-sdk = fetchFromGitHub {
    owner = "juicebox-systems";
    repo = "juicebox-sdk";
    tag = "0.3.4";
    hash = "sha256-WkrIoISdVO+JglX/F3e9bjwGJkufkryHGUIZHUjsFiM=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chat-xdk-go";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "xdevplatform";
    repo = "chat-xdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3EDYum1ASDEFlAK9QVzmmlvNDBFcrxd0y5MIVHuiRkg=";
  };

  cargoHash = "sha256-lUXTxMGSj5Yd5L3DIFMpK1P4QgzQYEmQTOaWwY5UjU8=";

  postPatch = ''
    rm -r go/chatxdk/libs
    substituteInPlace Cargo.toml \
      --replace-fail '../juicebox-sdk/rust/sdk' '${juicebox-sdk}/rust/sdk'
  '';

  cargoBuildFlags = [
    "-p"
    "chat-xdk-go"
  ];

  cargoTestFlags = [
    "-p"
    "chat-xdk-core"
    "-p"
    "chat-xdk-go"
  ];

  postInstall = ''
    install -Dm644 go/chatxdk/include/chat_xdk.h $out/include/chat_xdk.h
  '';

  meta = {
    description = "Native XChat encryption library for Go";
    homepage = "https://github.com/xdevplatform/chat-xdk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tensor5 ];
  };
})
