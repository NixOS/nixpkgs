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

<<<<<<< HEAD
    URL_VAULTWARDEN_DOCKER_SETTINGS="https://raw.githubusercontent.com/dani-garcia/vaultwarden/''${VAULTWARDEN_VERSION}/docker/DockerSettings.yaml"
    WEBVAULT_VERSION="$(curl --silent "$URL_VAULTWARDEN_DOCKER_SETTINGS" | yq -r ".vault_version")"
    URL_BW_WEBVAULT_DOCKERFILE="https://raw.githubusercontent.com/dani-garcia/bw_web_builds/refs/tags/''${WEBVAULT_VERSION}/Dockerfile"
    WEBVAULT_REV="$(curl --silent "$URL_BW_WEBVAULT_DOCKERFILE" | grep -m1 "^ARG VAULT_VERSION=" | cut -d'=' -f2)"
    URL_VW_WEBVAULT_TAGS="https://api.github.com/repos/vaultwarden/vw_web_builds/tags"
    WEBVAULT_TAG="$(curl --silent "$URL_VW_WEBVAULT_TAGS" | jq -r --arg rev "''${WEBVAULT_REV}" '.[] | select(.commit.sha == $rev) | .name')"
    nix-update "vaultwarden.webvault" --version "$WEBVAULT_TAG"
=======
    URL="https://raw.githubusercontent.com/dani-garcia/vaultwarden/''${VAULTWARDEN_VERSION}/docker/DockerSettings.yaml"
    WEBVAULT_VERSION="$(curl --silent "$URL" | yq -r ".vault_version" | sed s/^v//)"
    old_hash="$(nix --extra-experimental-features nix-command eval -f default.nix --raw vaultwarden.webvault.bw_web_builds.outputHash)"
    new_hash="$(nix-prefetch-git https://github.com/dani-garcia/bw_web_builds.git --rev "v$WEBVAULT_VERSION" | jq --raw-output ".sha256")"
    new_hash_sri="$(nix --extra-experimental-features nix-command hash to-sri --type sha256 "$new_hash")"
    sed -e "s#$old_hash#$new_hash_sri#" -i pkgs/tools/security/vaultwarden/webvault.nix
    nix-update "vaultwarden.webvault" --version "$WEBVAULT_VERSION"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';
})
