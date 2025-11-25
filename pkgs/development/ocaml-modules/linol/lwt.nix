{
  buildDunePackage,
  linol,
  lwt,
  yojson,
}:

buildDunePackage {
  pname = "linol-lwt";
  inherit (linol) version src;

  propagatedBuildInputs = [
    linol
    lwt
    yojson
  ];

  meta = linol.meta // {
    description = "LSP server library (with Lwt for concurrency)";
  };
}
