{
  writeScript,
  lib,
  runtimeShell,
  git,
  nix,
  common-updater-scripts,
  coreutils,
  curl,
  jq,
  nix-update,
  attrPath ? "zen-browser-unwrapped",
}:

writeScript "update-${attrPath}" ''
  #!${runtimeShell}
  PATH=${
    lib.makeBinPath [
      common-updater-scripts
      coreutils
      curl
      git
      jq
      nix
      nix-update
    ]
  }

  set -euo pipefail

  packageFile=pkgs/by-name/ze/zen-browser-unwrapped/package.nix

  if [[ ! -e $packageFile ]]; then
    echo "error: run this updater with the Nixpkgs repository root as the working directory" >&2
    exit 1
  fi

  zenVersion="$(curl --fail --silent --show-error \
    https://api.github.com/repos/zen-browser/desktop/releases/latest | jq -er .tag_name)"

  current="$(nix-instantiate --eval --strict --json -E '
    let
      tree = import ./.;
      pkgs = if builtins.isFunction tree then tree { } else tree;
    in
    {
      version = pkgs.zen-browser-unwrapped.version;
      firefoxVersion = pkgs.zen-browser-unwrapped.firefoxVersion;
      surferRev = pkgs.zen-browser-unwrapped.surferSrc.rev;
    }')"
  currentVersion="$(jq -er .version <<<"$current")"
  currentFirefoxVersion="$(jq -er .firefoxVersion <<<"$current")"
  currentSurferRev="$(jq -er .surferRev <<<"$current")"

  # Update the Zen version and its desktop source, including its hash.
  if [[ "$zenVersion" != "$currentVersion" ]]; then
    update-source-version "${attrPath}" "$zenVersion" \
      --version-key=version --source-key=desktopSrc --file="$packageFile"
  else
    echo "Zen Browser is already at $zenVersion"
  fi

  surferRev="$(curl --fail --silent --show-error \
    https://api.github.com/repos/zen-browser/surfer/commits/HEAD | jq -er .sha)"
  if [[ "$surferRev" != "$currentSurferRev" ]]; then
    surferCommit="$(curl --fail --silent --show-error \
      "https://api.github.com/repos/zen-browser/surfer/commits/$surferRev")"
    surferCommitDate="$(jq -er '.commit.committer.date' <<<"$surferCommit")"
    surferVersionBase="$(curl --fail --silent --show-error \
      "https://raw.githubusercontent.com/zen-browser/surfer/$surferRev/package.json" \
      | jq -er .version)"

    # A revision-only update does not require a different source hash, e.g. for
    # merge commits whose tree is identical, hence --ignore-same-hash.
    update-source-version "${attrPath}" "$surferVersionBase-unstable-''${surferCommitDate%T*}" \
      --version-key=surferVersion --source-key=surferSrc --rev="$surferRev" \
      --file="$packageFile" --ignore-same-hash

    nix-update --version=skip --no-src "${attrPath}.patchedSurfer" --override-filename "$packageFile"
  else
    echo "surfer is already pinned at $surferRev"
  fi

  firefoxVersion="$(curl --fail --silent --show-error \
    "https://raw.githubusercontent.com/zen-browser/desktop/$zenVersion/surfer.json" \
    | jq -er '.version.version')"
  if [[ "$firefoxVersion" != "$currentFirefoxVersion" ]]; then
    update-source-version "${attrPath}" "$firefoxVersion" \
      --version-key=firefoxVersion --source-key=firefoxSrc --file="$packageFile"
  else
    echo "Firefox is already at $firefoxVersion"
  fi

  if [[ "$zenVersion" != "$currentVersion" || "$firefoxVersion" != "$currentFirefoxVersion" ]]; then
    nix-update --version=skip --no-src "${attrPath}.src" --override-filename "$packageFile"
  fi

  echo "zen-browser-unwrapped is at $zenVersion with Firefox $firefoxVersion"
''
