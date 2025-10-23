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

  meta = with lib; {
    description = "Run Nottui UIs in Lwt";
    license = licenses.mit;
    maintainers = [ maintainers.alizter ];
    homepage = "https://github.com/let-def/lwd";
  };
}
