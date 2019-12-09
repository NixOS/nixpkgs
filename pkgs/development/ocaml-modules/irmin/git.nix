{ lib, buildDunePackage, git, irmin, irmin-mem, irmin-test, git-unix }:

buildDunePackage rec {

  pname = "irmin-git";

  inherit (irmin) version src;

  propagatedBuildInputs = [ git irmin ];

  checkInputs = lib.optionals doCheck [ git-unix irmin-mem irmin-test ];

  doCheck = true;

  meta = irmin.meta // {
    description = "Git backend for Irmin";
  };

}

