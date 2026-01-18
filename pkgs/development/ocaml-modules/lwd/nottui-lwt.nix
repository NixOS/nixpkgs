{
  lib,
  buildDunePackage,
  lwd,
  lwt,
  nottui,
}:

buildDunePackage {
  pname = "nottui-lwt";

  inherit (lwd) version src;

  propagatedBuildInputs = [
    lwt
    nottui
  ];

  meta = {
    description = "Run Nottui UIs in Lwt";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.alizter ];
    homepage = "https://github.com/let-def/lwd";
  };
}
