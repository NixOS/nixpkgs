{
  lib,
  buildDunePackage,
  dolmen,
  dolmen_loop,
  dolmen_type,
  linol,
  linol-lwt,
  logs,
  lsp,
}:

buildDunePackage {
  pname = "dolmen_lsp";
  inherit (dolmen) src version;

  patches = [ ./linol-common-migration.patch ];

  buildInputs = [
    dolmen
    dolmen_loop
    dolmen_type
    linol
    linol-lwt
    logs
    lsp
  ];

  meta = dolmen.meta // {
    description = "LSP server for automated deduction languages";
    mainProgram = "dolmenls";
    maintainers = [ lib.maintainers.stepbrobd ];
  };
}
