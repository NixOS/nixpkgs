/* This function provides a generic Erlang package builder. */

{ erlang, rebar }:

{ name

, buildInputs ? [rebar]

, installCommand ? 
    ''
      cp -R ebin $out/lib/$name
    ''

, buildPhase ?     
    ''
	rebar compile
    ''

, doCheck ? false

, preInstall ? ""
, postInstall ? ""

, meta ? {}

, ... } @ attrs:

# Keep extra attributes from ATTR, e.g., `patchPhase', etc.
erlang.stdenv.mkDerivation (attrs // {
  inherit doCheck buildPhase;

  name = name;

  # default to erlang's platforms and add maintainer(s) to every
  # package
  meta = {
    platforms = erlang.meta.platforms;
  } // meta // {
    maintainers = (meta.maintainers or []) ++ [ ];
  };

  # checkPhase after installPhase to run tests on installed packages
  phases = "unpackPhase buildPhase installPhase";

  buildInputs = [ erlang ] ++ buildInputs;

  installPhase = preInstall + ''

    echo "$name"
    mkdir -p "$out/lib/$name"

    echo "installing ${name}..."
    ERL_LIBS="$out/lib/:$ERL_LIBS"
    ${installCommand}

    ${postInstall}
    '';
})
