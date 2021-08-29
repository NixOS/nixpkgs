{ lib
, buildPythonPackage
, fetchPypi
, boltons
, attrs
, face
, pytest
, pyyaml
, isPy37
}:

buildPythonPackage rec {
  pname = "glom";
  version = "20.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "54051072bccc9cdb3ebbd8af0559195137a61d308f04bff19678e4b61350eb12";
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
