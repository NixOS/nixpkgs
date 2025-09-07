{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "yggdrasil-jumper";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "one-d-wide";
    repo = "yggdrasil-jumper";
    rev = "refs/tags/v${version}";
    hash = "sha256-5VLHX7sjtoIfBCOnS2RWUJKpzvchlkmI3obZZBf+rco=";
  };

  cargoHash = "sha256-HsxZNJXSXjyTz/ZB4MWD7CrLI136QL8HJs0X3rEuF9g=";

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
