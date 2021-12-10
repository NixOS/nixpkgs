{ lib
, buildPythonPackage
, fetchFromGitHub
, boltons
, attrs
, face
, pytest
, pyyaml
}:

buildPythonPackage rec {
  pname = "glom";
  version = "20.11.0";

  src = fetchFromGitHub {
     owner = "mahmoud";
     repo = "glom";
     rev = "v20.11.0";
     sha256 = "09yaqd4acmbzpmscxa11z7v8vz4i2y3q20f2ksnz06908y3jgmqw";
  };

  propagatedBuildInputs = [ boltons attrs face ];

  checkInputs = [ pytest pyyaml ];
  # test_cli.py checks the output of running "glom"
  checkPhase = "PATH=$out/bin:$PATH pytest glom/test";

  meta = with lib; {
    homepage = "https://github.com/mahmoud/glom";
    description = "Restructuring data, the Python way";
    longDescription = ''
      glom helps pull together objects from other objects in a
      declarative, dynamic, and downright simple way.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ twey ];
  };
}
