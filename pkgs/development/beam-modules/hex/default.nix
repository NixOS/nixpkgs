{ lib, stdenv, fetchFromGitHub, writeText, elixir }:

let
  shell = drv: stdenv.mkDerivation {
    name = "interactive-shell-${drv.name}";
    buildInputs = [ drv ];
  };

  pkg = self: stdenv.mkDerivation rec {
    pname = "hex";
    version = "0.21.1";

    src = fetchFromGitHub {
      owner = "hexpm";
      repo = "hex";
      rev = "v${version}";
      sha256 = "3V7hp+gK+ixEX+v9vkzQ5y81LN+CSzOIlSkCJB2RFb8=";
    };

    setupHook = writeText "setupHook.sh" ''
       addToSearchPath ERL_LIBS "$1/lib/erlang/lib/"
    '';

    dontStrip = true;

    buildInputs = [ elixir ];

    buildPhase = ''
      runHook preBuild
      export HEX_OFFLINE=1
      export HEX_HOME=./
      export MIX_ENV=prod
      mix compile
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/erlang/lib
      cp -r ./_build/prod/lib/hex $out/lib/erlang/lib/

      runHook postInstall
    '';

    meta = {
      description = "Package manager for the Erlang VM https://hex.pm";
      license = lib.licenses.mit;
      homepage = "https://github.com/hexpm/hex";
      maintainers = with lib.maintainers; [ ericbmerritt ];
    };

    passthru = {
      env = shell self;
    };
};
in lib.fix pkg
