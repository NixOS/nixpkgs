{ lib, buildDunePackage, lwd, nottui }:

buildDunePackage {
  pname = "nottui-pretty";

  inherit (lwd) version src;

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  propagatedBuildInputs = [ nottui ];

  meta = with lib; {
    description = "Pretty-printer based on PPrint rendering UIs";
    license = licenses.mit;
    maintainers = [ maintainers.alizter ];
    homepage = "https://github.com/let-def/lwd";
  };
}
