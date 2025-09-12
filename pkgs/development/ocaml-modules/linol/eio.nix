{
  buildDunePackage,
  eio,
  linol,
  yojson,
}:

buildDunePackage {
  pname = "linol-eio";
  inherit (linol) version src;

  propagatedBuildInputs = [
    eio
    linol
    yojson
  ];

  meta = linol.meta // {
    description = "LSP server library (with Eio for concurrency)";
  };
}
