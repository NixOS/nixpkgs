{ buildDunePackage, containers
, gen, iter, qcheck
}:

buildDunePackage {
  pname = "containers-data";

  inherit (containers) src version;

  doCheck = true;
  checkInputs = [ gen iter qcheck ];

  propagatedBuildInputs = [ containers ];

  meta = containers.meta // {
    description = "A set of advanced datatypes for containers";
  };
}
