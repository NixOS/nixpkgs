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
  version = "19.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c8a50cb9fcf0c84807836c6a73cf61285557834b9050d7bde7732b936aceb7dd";
  };

  propagatedBuildInputs = [ boltons attrs face ];

  checkInputs = [ pytest pyyaml ];
  checkPhase = "pytest glom/test";

  doCheck = !isPy37; # https://github.com/mahmoud/glom/issues/72

  meta = with stdenv.lib; {
    homepage = https://github.com/mahmoud/glom;
    description = "Restructuring data, the Python way";
    longDescription = ''
      glom helps pull together objects from other objects in a
      declarative, dynamic, and downright simple way.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ twey ];
  };
}
