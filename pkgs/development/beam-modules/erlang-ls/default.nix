{ fetchFromGitHub, fetchHex, stdenv, rebar3WithPlugins, lib }:
let
  version = "0.15.0";
  owner = "erlang-ls";
  repo = "erlang_ls";
  deps = import ./rebar-deps.nix { inherit fetchHex fetchFromGitHub; };
in stdenv.mkDerivation {
  inherit version;
  pname = "erlang-ls";
  buildInputs = [ (rebar3WithPlugins { }) ];
  src = fetchFromGitHub {
    inherit owner repo;
    sha256 = "1s6zk8r5plm7ajifz17mvfrnk5mzbhj7alayink9phqbmzrypnfg";
    rev = version;
  };
  buildPhase = ''
    mkdir _checkouts
    ${toString (lib.mapAttrsToList (k: v: ''
      cp -R ${v} _checkouts/${k}
    '') deps)}
    make
  '';
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
