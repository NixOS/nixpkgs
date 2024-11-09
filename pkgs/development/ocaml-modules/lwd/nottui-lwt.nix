{ lib, buildDunePackage, lwd, lwt, nottui }:

buildDunePackage {
  pname = "nottui-lwt";

  inherit (lwd) version src;

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  propagatedBuildInputs = [ lwt nottui ];

  meta = with lib; {
    description = "Run Nottui UIs in Lwt";
    license = licenses.mit;
    maintainers = [ maintainers.alizter ];
    homepage = "https://github.com/let-def/lwd";
  };
}
