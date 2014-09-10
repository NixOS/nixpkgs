{ stdenv, fetchurl, erlang, rebar, makeWrapper, coreutils }:

let
  version = "1.0.0";
in
stdenv.mkDerivation {
  name = "elixir-${version}";

  src = fetchurl {
    url = "https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz";
    sha256 = "1ci8g6nh89xnn0ax9kazcs47w406nqsj1d4rf8sb1b6abfq78xsj";
  };

  buildInputs = [ erlang rebar makeWrapper ];

  preBuild = ''
    # The build process uses ./rebar. Link it to the nixpkgs rebar
    rm -v rebar
    ln -s ${rebar}/bin/rebar rebar

    substituteInPlace Makefile \
      --replace "/usr/local" $out
  '';

  postFixup = ''
    # Elixir binaries are shell scripts which run erl. Add some stuff
    # to PATH so the scripts can run without problems.

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
      Elixir is a functional, meta-programming aware language built on
      top of the Erlang VM. It is a dynamic language with flexible
      syntax and macro support that leverages Erlang's abilities to
      build concurrent, distributed and fault-tolerant applications
      with hot code upgrades.
    '';

    license = licenses.epl10;
    platforms = platforms.unix;
    maintainers = [ maintainers.the-kenny ];
  };
}
