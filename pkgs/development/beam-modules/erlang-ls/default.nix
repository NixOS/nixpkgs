{
  erlang,
  fetchFromGitHub,
  fetchgit,
  fetchHex,
  rebar3Relx,
  buildRebar3,
  rebar3-proper,
  stdenv,
  writeScript,
  lib,
}:
let
  version = "1.1.0";
  owner = "erlang-ls";
  repo = "erlang_ls";

  deps = import ./rebar-deps.nix {
    inherit fetchHex fetchFromGitHub fetchgit;
    builder = buildRebar3;
    overrides = (
      self: super: {
        proper = super.proper.overrideAttrs (_: {
          configurePhase = "true";
        });
        redbug = super.redbug.overrideAttrs (_: {
          patchPhase = ''
            substituteInPlace rebar.config --replace ", warnings_as_errors" ""
          '';
        });
        json_polyfill = super.json_polyfill.overrideAttrs (_: {
          # When compiling with erlang >= 27, the json_polyfill rebar script will
          # delete the json.beam file as it's not needed. However, we need to
          # adjust this path as the nix build will put the beam file under `ebin`
          # instead of `$REBAR_DEPS_DIR/json_polyfill/ebin`.
          postPatch = ''
            substituteInPlace rebar.config.script --replace "{erlc_compile, \"rm \\\"\$REBAR_DEPS_DIR/json_polyfill/ebin/json.beam\\\"\"}" "{erlc_compile, \"rm \\\"ebin/json.beam\\\"\"}"
          '';
        });
      }
    );
  };
in
rebar3Relx {
  pname = "erlang-ls";

  inherit version;

  src = fetchFromGitHub {
    inherit owner repo;
    hash = "sha256-MSDBU+blsAdeixaHMMXmeMJ+9Yrzn3HekE8KbIc/Guo=";
    rev = version;
  };

  # remove when fixed upstream https://github.com/erlang-ls/erlang_ls/pull/1576
  patches = lib.optionals (lib.versionAtLeast erlang.version "27") [ ./1576.diff ];

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
  installFlags = [ "PREFIX=$(out)" ];

  # tests seem to be a bit flaky on darwin, skip them for now
  doCheck = !stdenv.hostPlatform.isDarwin;

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
      nixfmt "$nix_path/rebar-deps.nix"
    else
      echo "erlang-ls is already up-to-date"
    fi
  '';

  meta = with lib; {
    homepage = "https://github.com/erlang-ls/erlang_ls";
    description = "Erlang Language Server";
    platforms = platforms.unix;
    license = licenses.asl20;
    mainProgram = "erlang_ls";
  };
}
