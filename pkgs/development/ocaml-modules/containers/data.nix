{ buildDunePackage, containers
, dune-configurator
, gen, iter, qcheck
}:

buildDunePackage {
  pname = "containers-data";

  inherit (containers) src version doCheck useDune2;

  buildInputs = [ dune-configurator ];
  checkInputs = [ gen iter qcheck ];

  propagatedBuildInputs = [ containers ];

  meta = containers.meta // {
    description = "A set of advanced datatypes for containers";
  };
}
