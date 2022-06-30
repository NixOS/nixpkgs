{ fetchFromGitHub, fetchgit, fetchHex, rebar3Relx, buildRebar3, rebar3-proper
, stdenv, writeScript, lib }:
let
  version = "0.35.0";
  owner = "erlang-ls";
  repo = "erlang_ls";
  deps = import ./rebar-deps.nix {
    inherit fetchHex fetchFromGitHub fetchgit;
    builder = buildRebar3;
    overrides = (self: super: {
      proper = super.proper.overrideAttrs (_: {
        configurePhase = "true";
      });
    });
  };
in
rebar3Relx {
  pname = "erlang-ls";
  inherit version;
  src = fetchFromGitHub {
    inherit owner repo;
    sha256 = "sha256-5pGFLatcNqxpQZtu/qgwX88C8TZvk+U8ez2IGf+jgRA=";
    rev = version;
  };
  releaseType = "escript";
  beamDeps = builtins.attrValues deps;
  buildPlugins = [ rebar3-proper ];
  buildPhase = "HOME=. make";
  # based on https://github.com/erlang-ls/erlang_ls/blob/main/.github/workflows/build.yml
  # these tests are excessively long and we should probably skip them
  checkPhase = ''
    HOME=. epmd -daemon
    HOME=. rebar3 ct
    HOME=. rebar3 proper --constraint_tries 100
  '';
  # tests seem to be a bit flaky on darwin, skip them for now
  doCheck = !stdenv.isDarwin;
  installPhase = ''
    mkdir -p $out/bin
    cp _build/default/bin/erlang_ls $out/bin/
    cp _build/dap/bin/els_dap $out/bin/
  '';
  meta = with lib; {
    homepage = "https://github.com/erlang-ls/erlang_ls";
    description = "The Erlang Language Server";
    platforms = platforms.unix;
    license = licenses.asl20;
  };
  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #! nix-shell -i bash -p common-updater-scripts coreutils git gnused gnutar gzip "rebar3WithPlugins { globalPlugins = [ beamPackages.rebar3-nix ]; }"

    set -ox errexit
    latest=$(list-git-tags | sed -n '/[\d\.]\+/p' | sort -V | tail -1)
    if [[ "$latest" != "${version}" ]]; then
      nixpkgs="$(git rev-parse --show-toplevel)"
      nix_path="$nixpkgs/pkgs/development/beam-modules/erlang-ls"
      update-source-version erlang-ls "$latest" --version-key=version --print-changes --file="$nix_path/default.nix"
      tmpdir=$(mktemp -d)
      cp -R $(nix-build $nixpkgs --no-out-link -A erlang-ls.src)/* "$tmpdir"
      DEBUG=1
      (cd "$tmpdir" && HOME=. rebar3 as test nix lock -o "$nix_path/rebar-deps.nix")
    else
      echo "erlang-ls is already up-to-date"
    fi
  '';
}
