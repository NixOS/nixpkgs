{ lib, buildPythonPackage, fetchFromGitHub, scipy }:

buildPythonPackage rec {
  pname = "iapws";
  version = "1.5.2";

  src = fetchFromGitHub {
     owner = "jjgomera";
     repo = "iapws";
     rev = "v1.5.2";
     sha256 = "1pj1wgb7ri69aprjqy19rnz7wzn63xlazg6gw5s1gjinpmmsix0f";
  };

  propagatedBuildInputs = [ scipy ];

  meta = with lib; {
    description = "Python implementation of standard from IAPWS";
    homepage = "https://github.com/jjgomera/iapws";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dawidsowa ];
  };
}
