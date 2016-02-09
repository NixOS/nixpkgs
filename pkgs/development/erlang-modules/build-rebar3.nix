{ stdenv, writeText, erlang, rebar3, openssl, libyaml, fetchHex, fetchFromGitHub,
  pc, buildEnv }:

{ name, version
, src
, setupHook ? null
, buildInputs ? [], erlangDeps ? [], buildPlugins ? []
, postPatch ? ""
, compilePorts ? false
, installPhase ? null
, meta ? {}
, ... }@attrs:

with stdenv.lib;

let
  ownPlugins = buildPlugins ++ (if compilePorts then [pc] else []);

  shell = drv: stdenv.mkDerivation {
          name = "interactive-shell-${drv.name}";
          buildInputs = [ drv ];
    };

  pkg = self: stdenv.mkDerivation (attrs // {

    name = "${name}-${version}";
    inherit version;

    buildInputs = buildInputs ++ [ erlang rebar3 openssl libyaml ];
    propagatedBuildInputs = unique (erlangDeps ++ ownPlugins);

    # The following are used by rebar3-nix-bootstrap
    inherit compilePorts;
    buildPlugins = ownPlugins;

    inherit src;

    setupHook = if setupHook == null
    then writeText "setupHook.sh" ''
       addToSearchPath ERL_LIBS "$1/lib/erlang/lib/"
    ''
    else setupHook;

    postPatch = ''
      rm -f rebar rebar3
    '';

    configurePhase = ''
      runHook preConfigure
      rebar3-nix-bootstrap
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild
      HOME=. rebar3 compile
      ${if compilePorts then ''
        HOME=. rebar3 pc compile
      '' else ''''}
      runHook postBuild
    '';

    installPhase = if installPhase == null
    then ''
      runHook preInstall
      mkdir -p "$out/lib/erlang/lib/${name}-${version}"
      for reldir in src ebin priv include; do
        fd="_build/default/lib/${name}/$reldir"
        [ -d "$fd" ] || continue
        cp -Hrt "$out/lib/erlang/lib/${name}-${version}" "$fd"
        success=1
      done
      runHook postInstall
    ''
    else installPhase;

    meta = {
      inherit (erlang.meta) platforms;
    } // meta;

    passthru = {
      packageName = name;
      env = shell self;
      inherit erlangDeps;
    };
  });
in
  fix pkg
