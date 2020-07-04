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
  version = "20.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e753d2e8d16647ffcd9f0f99ac85d3db523ff0a1f097cf0a154a60702bca7e42";
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
