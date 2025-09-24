{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "yggdrasil-jumper";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "one-d-wide";
    repo = "yggdrasil-jumper";
    rev = "refs/tags/v${version}";
    hash = "sha256-Op3KBJ911AjB7BIJuV4xR8KHMxBtQj7hf++tC1g7SlM=";
  };

  cargoHash = "sha256-EbG83rGlUbiJC1qm9H1+YrCFSq23kSDeW7KMHP8Wee8=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Reduce latency of a connection over Yggdrasil Network";
    longDescription = ''
      An independent project that aims to transparently reduce latency
      of a connection over Yggdrasil network, utilizing NAT traversal to
      bypass intermediary nodes. It periodically probes for active sessions
      and automatically establishes direct peerings over internet with
      remote nodes running Yggdrasil-Jumper without requiring any firewall
      configuration or port mapping.
    '';
    homepage = "https://github.com/one-d-wide/yggdrasil-jumper";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ one-d-wide ];
  };
}
