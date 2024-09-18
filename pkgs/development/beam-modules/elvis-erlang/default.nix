{ fetchFromGitHub, fetchgit, fetchHex, rebar3Relx
, buildRebar3, writeScript, lib }:

let
  owner = "inaka";
  repo = "elvis";
in rebar3Relx rec {
  releaseType = "escript";
  # The package name "elvis" is already taken
  pname = "elvis-erlang";
  version = "3.2.5";
  src = fetchFromGitHub {
    inherit owner repo;
    sha256 = "I0GgfNyozkrM1PRkIXwANr1lji4qZCtOQ/bBEgZc5gc=";
    rev = version;
  };
  beamDeps = builtins.attrValues (import ./rebar-deps.nix {
    inherit fetchHex fetchgit fetchFromGitHub;
    builder = buildRebar3;
  });
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
    else
      echo "${repo} is already up-to-date"
    fi
  '';
  meta = with lib; {
    homepage = "https://github.com/inaka/elvis";
    description = "Erlang Style Reviewer";
    platforms = platforms.unix;
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ dlesl ];
    mainProgram = "elvis";
  };
}
