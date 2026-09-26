{
  buildDunePackage,
  linol,
  lwt,
}:

buildDunePackage {
  pname = "linol-lwt";
  inherit (linol) version src patches;

  propagatedBuildInputs = [
    linol
    lwt
  ];

  meta = linol.meta // {
    description = "LSP server library (with Lwt for concurrency)";
  };
}
