{
  writeShellApplication,
  lib,
  nix,
  nix-prefetch-git,
  nix-update,
  curl,
  git,
  gnugrep,
  gnused,
  jq,
  yq,
}:

lib.getExe (writeShellApplication {
  name = "update-vaultwarden";
  runtimeInputs = [
    curl
    git
    gnugrep
    gnused
    jq
    yq
    nix
    nix-prefetch-git
    nix-update
  ];

  text = ''
    VAULTWARDEN_VERSION=$(curl --silent https://api.github.com/repos/dani-garcia/vaultwarden/releases/latest | jq -r '.tag_name')
    nix-update "vaultwarden" --version "$VAULTWARDEN_VERSION"

    URL_VAULTWARDEN_DOCKER_SETTINGS="https://raw.githubusercontent.com/dani-garcia/vaultwarden/''${VAULTWARDEN_VERSION}/docker/DockerSettings.yaml"
    WEBVAULT_VERSION="$(curl --silent "$URL_VAULTWARDEN_DOCKER_SETTINGS" | yq -r ".vault_version")"
    URL_BW_WEBVAULT_DOCKERFILE="https://raw.githubusercontent.com/dani-garcia/bw_web_builds/refs/tags/''${WEBVAULT_VERSION}/Dockerfile"
    WEBVAULT_REV="$(curl --silent "$URL_BW_WEBVAULT_DOCKERFILE" | grep -m1 "^ARG VAULT_VERSION=" | cut -d'=' -f2)"
    URL_VW_WEBVAULT_TAGS="https://api.github.com/repos/vaultwarden/vw_web_builds/tags"
    WEBVAULT_TAG="$(curl --silent "$URL_VW_WEBVAULT_TAGS" | jq -r --arg rev "''${WEBVAULT_REV}" '.[] | select(.commit.sha == $rev) | .name')"
    nix-update "vaultwarden.webvault" --version "$WEBVAULT_TAG"
  '';
})
