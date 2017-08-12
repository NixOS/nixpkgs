{stdenv, fetchFromGitHub, buildRebar3 }:

let
  shell = drv: stdenv.mkDerivation {
          name = "interactive-shell-${drv.name}";
          buildInputs = [ drv ];
    };

  pkg = self: buildRebar3 rec {
    name = "pgsql";
    version = "25+beta.2";

    src = fetchFromGitHub {
        owner = "semiocast";
        repo = "pgsql";
        rev = "14f632bc89e464d82ce3ef12a67ed8c2adb5b60c";
        sha256 = "17dcahiwlw61zhy8aq9rn46lwb35fb9q3372s4wmz01czm8c348w";
    };

    dontStrip = true;

    meta = {
      description = "Erlang PostgreSQL Driver";
      license = stdenv.lib.licenses.mit;
      homepage = https://github.com/semiocast/pgsql;
      maintainers = with stdenv.lib.maintainers; [ ericbmerritt ];
    };

    passthru = {
      env = shell self;
    };

};
in stdenv.lib.fix pkg
