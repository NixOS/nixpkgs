{ stdenv, fetchurl, erlang, rebar, makeWrapper, coreutils, curl, bash, cacert }:

let
  version = "1.0.4";
in
stdenv.mkDerivation {
  name = "elixir-${version}";

  src = fetchurl {
    url = "https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz";
    sha256 = "1babp3ff6hajdm247zl9rc311k973cdnv6dqaai7l8817gg1yd3r";
  };

  buildInputs = [ erlang rebar makeWrapper ];

  preBuild = ''
    # The build process uses ./rebar. Link it to the nixpkgs rebar
    rm -v rebar
    ln -s ${rebar}/bin/rebar rebar

    substituteInPlace Makefile \
      --replace "/usr/local" $out
    substituteInPlace bin/mix \
      --replace "/usr/bin/env elixir" "$out/bin/elixir"
  '';

  postFixup = ''
    # Elixir binaries are shell scripts which run erl. Add some stuff
    # to PATH so the scripts can run without problems.

    for f in $out/bin/*; do
     b=$(basename $f)
      if [ $b == "mix" ]; then continue; fi
      wrapProgram $f \
      --prefix PATH ":" "${erlang}/bin:${coreutils}/bin:${curl}/bin:${bash}/bin" \
      --set CURL_CA_BUNDLE "${cacert}/etc/ssl/certs/ca-bundle.crt"
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
