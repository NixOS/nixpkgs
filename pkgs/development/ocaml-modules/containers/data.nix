{ buildDunePackage, containers
, gen, iter, mdx, ounit, qcheck
}:

buildDunePackage {
  pname = "containers-data";

  inherit (containers) src version;

  doCheck = true;
  checkInputs = [ gen iter mdx.bin ounit qcheck ];

  propagatedBuildInputs = [ containers ];

  meta = containers.meta // {
    description = "A set of advanced datatypes for containers";
  };
}
