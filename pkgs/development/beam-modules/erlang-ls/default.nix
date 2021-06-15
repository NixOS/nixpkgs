{ fetchFromGitHub, fetchHex, rebar3Relx, buildRebar3, rebar3-proper, lib }:
let
  version = "0.16.0";
  owner = "erlang-ls";
  repo = "erlang_ls";
  deps = import ./rebar-deps.nix {
    inherit fetchHex fetchFromGitHub;
    builder = buildRebar3;
    overrides = (self: super: {
      proper = super.proper.overrideAttrs (_: {
        configurePhase = "true";
      });
    });
  };
in rebar3Relx {
  name = "erlang-ls";
  inherit version;
  src = fetchFromGitHub {
    inherit owner repo;
    sha256 = "0l09yhj3rsb9zj4cs6a1bcfmi6zbyb3xk1lv494xbyiv5d61vkwm";
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
  doCheck = true;
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
}
