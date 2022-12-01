{ lib, fetchurl, ... }:
let
  version = "1.7.3.0";
in fetchurl {
  name = "prototype-${version}.js";
  url = "https://ajax.googleapis.com/ajax/libs/prototype/${version}/prototype.js";
  sha256 = "0q43vvrsb22h4jvavs1gk3v4ps61yx9k85b5n6q9mxivhmxprg26";

  meta = with lib; {
    description = "A foundation for ambitious web user interfaces";
    longDescription = ''
      Prototype takes the complexity out of client-side web
      programming. Built to solve real-world problems, it adds
      useful extensions to the browser scripting environment
      and provides elegant APIs around the clumsy interfaces
      of Ajax and the Document Object Model.
    '';
    homepage = "http://prototypejs.org/";
    downloadPage = "http://prototypejs.org/download/";
    license = licenses.mit;
    maintainers = with maintainers; [ das_j ];
  };
}
