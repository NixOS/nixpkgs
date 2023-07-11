{ lib, buildDunePackage, linol, jsonrpc, lwt, yojson }:

buildDunePackage {
  pname = "linol-lwt";
  inherit (linol) version src;

  duneVersion = "3";

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
