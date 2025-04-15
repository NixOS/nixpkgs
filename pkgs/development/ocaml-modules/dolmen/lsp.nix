{
  lib,
  buildDunePackage,
  dolmen,
  dolmen_loop,
  dolmen_type,
  linol,
  linol-lwt,
  logs,
# lsp, # transitive dependency from linol
}:

buildDunePackage {
  pname = "dolmen_lsp";
  inherit (dolmen) src version;

  patches = [ ./linol-lwt-6.patch ];

  buildInputs = [
    dolmen
    dolmen_loop
    dolmen_type
    linol
    linol-lwt
    logs
    # lsp # transitive dependency from linol
  ];

  meta = dolmen.meta // {
    description = "A LSP server for automated deduction languages";
    mainProgram = "dolmenls";
    maintainers = [ lib.maintainers.stepbrobd ];
  };
}
