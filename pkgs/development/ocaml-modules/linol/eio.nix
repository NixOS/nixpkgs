{
  buildDunePackage,
  eio,
  linol,
}:

buildDunePackage {
  pname = "linol-eio";
  inherit (linol) version src;

  propagatedBuildInputs = [
    eio
    linol
  ];

  meta = linol.meta // {
    description = "LSP server library (with Eio for concurrency)";
  };
}
