{
  buildDunePackage,
  containers,
  ocaml,
  dune-configurator,
  gen,
  iter,
  qcheck-core,
  mdx,
}:

buildDunePackage {
  pname = "containers-data";

  inherit (containers) src version;

  doCheck = containers.doCheck && ocaml.meta.branch != "5.0";

  buildInputs = [ dune-configurator ];
  nativeCheckInputs = [ mdx.bin ];
  checkInputs = [
    gen
    iter
    qcheck-core
  ];

  propagatedBuildInputs = [ containers ];

  meta = containers.meta // {
    description = "A set of advanced datatypes for containers";
  };
}
