{ buildDunePackage, containers
, dune-configurator
, gen, iter, qcheck-core
}:

buildDunePackage {
  pname = "containers-data";

  inherit (containers) src version doCheck;

  duneVersion = "3";

  buildInputs = [ dune-configurator ];
  checkInputs = [ gen iter qcheck-core ];

  propagatedBuildInputs = [ containers ];

  meta = containers.meta // {
    description = "A set of advanced datatypes for containers";
  };
}
