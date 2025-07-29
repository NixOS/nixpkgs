{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "unwaf";
  version = "0-unstable-2025-07-04";

  src = fetchFromGitHub {
    owner = "mmarting";
    repo = "unwaf";
    rev = "06f19a49d048be1f92f395d04c43c9a2a36d2ab5";
    hash = "sha256-9gM82vv7Qx4VQv7Ojg2rpmC6SN9olqF+07ovjn7Z3CM=";
  };

  vendorHash = "sha256-jCL0mEGuiUeruQq6u7wOczqNwT343xtMYkit6QKbZuk=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool designed to help identify WAF bypasses using passive techniques";
    homepage = "https://github.com/mmarting/unwaf";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "unwaf";
  };
}
