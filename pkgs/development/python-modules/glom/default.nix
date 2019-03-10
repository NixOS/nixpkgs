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
  version = "19.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c47dc6dc97bb1c20e5607f3d58eac81e13b16880a284b52d503eea92d7b5fc2";
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
