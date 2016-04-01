{ stdenv, fetchurl, erlang, rebar, makeWrapper, coreutils, curl, bash,
  debugInfo ? false }:

stdenv.mkDerivation rec {
  name = "elixir-${version}";
  version = "1.2.4";

  src = fetchurl {
    url = "https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz";
    sha256 = "16759ff84d08b480b7e5499716e663b2fffd26e20cf2863de5613bc7bb05c817";
  };

  buildInputs = [ erlang rebar makeWrapper ];

  # Elixir expects that UTF-8 locale to be set (see https://github.com/elixir-lang/elixir/issues/3548).
  # In other cases there is warnings during compilation.
  LANG = "en_US.UTF-8";
  LC_TYPE = "en_US.UTF-8";

  setupHook = ./setup-hook.sh;

  buildFlags = if debugInfo
   then "ERL_COMPILER_OPTIONS=debug_info"
   else "";

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

    for f in $out/bin/*; do
     b=$(basename $f)
      if [ $b == "mix" ]; then continue; fi
      wrapProgram $f \
        --prefix PATH ":" "${erlang}/bin:${coreutils}/bin:${curl.bin}/bin:${bash}/bin" \
        --set CURL_CA_BUNDLE /etc/ssl/certs/ca-certificates.crt
    done

    substituteInPlace $out/bin/mix \
          --replace "/usr/bin/env elixir" "${coreutils}/bin/env elixir"
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
    maintainers = with maintainers; [ the-kenny havvy couchemar ];
  };
}
