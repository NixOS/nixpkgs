{ stdenv, fetchurl, erlang, rebar, makeWrapper, coreutils }:

stdenv.mkDerivation {
  name = "elixir-0.10.1";

  src = fetchurl {
    url = "https://github.com/elixir-lang/elixir/archive/v0.10.1.tar.gz";
    sha256 = "0gfr2bz3mw7ag9z2wb2g22n2vlyrp8dwy78fj9zi52kzl5w3vc3w";
  };

  buildInputs = [ erlang rebar makeWrapper ];

  preBuild = ''
    substituteInPlace rebar \
      --replace "/usr/bin/env escript" ${erlang}/bin/escript
    substituteInPlace Makefile \
      --replace '$(shell echo `pwd`/rebar)' ${rebar}/bin/rebar \
      --replace "/usr/local" $out
  '';

  postFixup = ''
    # Elixirs binaries are shell scripts which run erl. This adds some
    # stuff to PATH so the scripts run without problems.

    for f in $out/bin/*
    do
      wrapProgram $f \
      --prefix PATH ":" "${erlang}/bin:${coreutils}/bin"
    done
  '';

  meta = with stdenv.lib; {
    homepage = "http://elixir-lang.org/";
    description = "A functional, meta-programming aware language built on top of the Erlang VM";

    longDescription = ''
      Elixir is a functional, meta-programming
      aware language built on top of the Erlang VM. It is a dynamic
      language with flexible syntax and macro support that leverages
      Erlang's abilities to build concurrent, distributed and
      fault-tolerant applications with hot code upgrades.p
    '';

    license = licenses.epl10;
    platforms = platforms.linux;
    maintainers = [ maintainers.the-kenny ];
  };
}
