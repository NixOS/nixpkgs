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
  version = "18.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rfikq27a9wwfkd4k3bk7x4fssw6r7z138g9i3wpzvjc7anlzk24";
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
