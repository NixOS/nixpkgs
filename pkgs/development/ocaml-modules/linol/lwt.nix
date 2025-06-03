{
  buildDunePackage,
  linol,
  jsonrpc,
  lwt,
  yojson,
}:

buildDunePackage {
  pname = "linol-lwt";
  inherit (linol) version src;

  propagatedBuildInputs = [
    linol
    jsonrpc
    lwt
    yojson
  ];

  meta = linol.meta // {
    description = "LSP server library (with Lwt for concurrency)";
  };
}
