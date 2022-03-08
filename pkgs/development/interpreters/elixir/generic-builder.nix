{ pkgs
, lib
, stdenv
, fetchFromGitHub
, erlang
, makeWrapper
, coreutils
, curl
, bash
, debugInfo ? false
}:

{ baseName ? "elixir"
, version
, minimumOTPVersion
, sha256 ? null
, rev ? "v${version}"
, src ? fetchFromGitHub { inherit rev sha256; owner = "elixir-lang"; repo = "elixir"; }
} @ args:

let
  inherit (lib) getVersion versionAtLeast optional;

in
assert versionAtLeast (getVersion erlang) minimumOTPVersion;

stdenv.mkDerivation ({
  pname = "${baseName}";

  inherit src version debugInfo;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ erlang ];

  LANG = "C.UTF-8";
  LC_TYPE = "C.UTF-8";

  buildFlags = optional debugInfo "ERL_COMPILER_OPTIONS=debug_info";

  preBuild = ''
    patchShebangs lib/elixir/generate_app.escript || true

    substituteInPlace Makefile \
      --replace "/usr/local" $out
  '';

  postFixup = ''
    # Elixir binaries are shell scripts which run erl. Add some stuff
    # to PATH so the scripts can run without problems.

    for f in $out/bin/*; do
     b=$(basename $f)
      if [ "$b" = mix ]; then continue; fi
      wrapProgram $f \
        --prefix PATH ":" "${lib.makeBinPath [ erlang coreutils curl bash ]}"
    done

    substituteInPlace $out/bin/mix \
          --replace "/usr/bin/env elixir" "${coreutils}/bin/env elixir"
  '';

  pos = builtins.unsafeGetAttrPos "sha256" args;
  meta = with lib; {
    homepage = "https://elixir-lang.org/";
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
    maintainers = teams.beam.members;
  };
})
