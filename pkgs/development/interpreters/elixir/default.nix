{ stdenv, fetchurl, erlang, rebar }:

stdenv.mkDerivation {
  name = "elixir-0.10.1";

  src = fetchurl {
    url = "https://github.com/elixir-lang/elixir/archive/v0.10.1.tar.gz";
    sha256 = "0gfr2bz3mw7ag9z2wb2g22n2vlyrp8dwy78fj9zi52kzl5w3vc3w";
  };

  buildInputs = [ erlang rebar ];

  preBuild = ''
    substituteInPlace rebar \
      --replace "/usr/bin/env escript" ${erlang}/bin/escript
    substituteInPlace Makefile \
      --replace '$(shell echo `pwd`/rebar)' ${rebar}/bin/rebar \
      --replace "/usr/local" $out
  '';
}
