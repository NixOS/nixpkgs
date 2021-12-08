{ lib, buildPythonPackage, fetchFromGitHub, click }:

buildPythonPackage rec {
  pname = "click-log";
  version = "0.3.2";

  src = fetchFromGitHub {
     owner = "click-contrib";
     repo = "click-log";
     rev = "0.3.2";
     sha256 = "01zpjyqnyzrx6xi7cii2180bqdcg2a6b1sdbjijri8jv755r7ray";
  };

  propagatedBuildInputs = [ click ];

  meta = with lib; {
    homepage = "https://github.com/click-contrib/click-log/";
    description = "Logging integration for Click";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
