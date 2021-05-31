{ fetchFromGitHub, fetchHex, rebar3Relx, buildRebar3, lib }:
let
  version = "0.16.0";
  owner = "erlang-ls";
  repo = "erlang_ls";
  deps = import ./rebar-deps.nix {
    inherit fetchHex fetchFromGitHub;
    builder = buildRebar3;
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
  buildPhase = "HOME=. make";
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
