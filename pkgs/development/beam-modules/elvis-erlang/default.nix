{
  buildRebar3,
  fetchFromGitHub,
  fetchHex,
  fetchgit,
  lib,
  rebar3Relx,
  writeScript,
}:

rebar3Relx rec {
  releaseType = "escript";
  pname = "elvis-erlang";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "inaka";
    repo = "elvis";
    hash = "sha256-O6T3/oe7npeLaaCRZLn4CtZ1WTjg98aPP9mrQoWCXgg=";
    tag = version;
  };

  beamDeps = builtins.attrValues (
    import ./rebar-deps.nix {
      inherit fetchHex fetchgit fetchFromGitHub;
      builder = buildRebar3;
    }
  );

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p bash common-updater-scripts git nix-prefetch-git gnutar gzip "rebar3WithPlugins {globalPlugins = [beamPackages.rebar3-nix];}"

    set -euo pipefail

    latest=$(list-git-tags | sort -V | tail -1)
    if [ "$latest" != "${version}" ]; then
      nixpkgs="$(git rev-parse --show-toplevel)"
      nix_path="$nixpkgs/pkgs/development/beam-modules/elvis-erlang"
      update-source-version elvis-erlang "$latest" --version-key=version --print-changes --file="$nix_path/default.nix"
      tmpdir=$(mktemp -d)
      cp -R $(nix-build $nixpkgs --no-out-link -A elvis-erlang.src)/* "$tmpdir"
      (cd "$tmpdir" && HOME=. rebar3 nix lock -o "$nix_path/rebar-deps.nix")
      nixfmt "$nix_path/rebar-deps.nix"
    else
      echo "elvis-erlang is already up-to-date"
    fi
  '';

  meta = {
    homepage = "https://github.com/inaka/elvis";
    description = "Erlang Style Reviewer";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dlesl ];
    mainProgram = "elvis";
  };
}
