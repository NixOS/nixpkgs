{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "yggdrasil-jumper";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "one-d-wide";
    repo = "yggdrasil-jumper";
    rev = "refs/tags/v${version}";
    hash = "sha256-e/QTLWqRlEFMl3keQMeJaxfVJh28W/WbuUsmEAaLAf4=";
  };

  cargoHash = "sha256-aWDeRcOV/5x0BB0aunp52en9hIuPrYr+pNgLCjiscaE=";

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
