{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  version = "0.3";
  pname = "httpauth";

  src = fetchFromGitHub {
     owner = "jonashaag";
     repo = "httpauth";
     rev = "0.3";
     sha256 = "0vwpgl5sh4l5wzjb5j1s60mrvddsbcgspn4wmyn6vvd6ijflsg08";
  };

  doCheck = false;

  meta = with lib; {
    description = "WSGI HTTP Digest Authentication middleware";
    homepage = "https://github.com/jonashaag/httpauth";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };

}
