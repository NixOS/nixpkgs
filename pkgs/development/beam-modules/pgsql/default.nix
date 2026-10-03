{
  lib,
  stdenv,
  fetchFromGitHub,
  buildRebar3,
}:

let
  shell =
    drv:
    stdenv.mkDerivation {
      name = "interactive-shell-${drv.name}";
      buildInputs = [ drv ];
    };

  pkg =
    self:
    buildRebar3 {
      name = "pgsql";
      version = "25+beta.2";

      src = fetchFromGitHub {
        owner = "semiocast";
        repo = "pgsql";
        rev = "14f632bc89e464d82ce3ef12a67ed8c2adb5b60c";
        hash = "sha256-HJHBUP0sgF850eKMgdNyZSxODbE5YYU8/MFwyiNUrJ0=";
      };

      dontStrip = true;

      meta = {
        description = "Erlang PostgreSQL Driver";
        license = lib.licenses.mit;
        homepage = "https://github.com/semiocast/pgsql";
        maintainers = with lib.maintainers; [ ericbmerritt ];
      };

      passthru = {
        env = shell self;
      };

    };
in
lib.fix pkg
