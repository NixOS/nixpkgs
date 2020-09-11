{ stdenv
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
  version = "20.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5fa3a9d99c7f3e5410a810fa8a158c0f71e39036c47b77745c7f2e4630372f82";
  };

  propagatedBuildInputs = [ boltons attrs face ];

  checkInputs = [ pytest pyyaml ];
  checkPhase = "pytest glom/test";

  doCheck = !isPy37; # https://github.com/mahmoud/glom/issues/72

  meta = with stdenv.lib; {
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
