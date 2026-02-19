{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yggdrasil-jumper";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "one-d-wide";
    repo = "yggdrasil-jumper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dElC+q76dE3SlVY4+aauNmeqcNdfj0mMjg51WRuywJI=";
  };

  cargoHash = "sha256-hCKw+kmcnNF8U3KyBjPjBeeA8abZf/oYtimtUFo7t7w=";

  passthru.updateScript = nix-update-script { };

  meta = {
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
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ one-d-wide ];
  };
})
