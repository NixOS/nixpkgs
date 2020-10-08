{ stdenv
, pythonAtLeast
, buildPythonPackage
, fetchPypi
, nose
, coverage
}:

buildPythonPackage rec {
  pname = "globre";
  version = "0.1.5";
  # https://github.com/metagriffin/globre/issues/7
  disabled = pythonAtLeast "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qhjpg0722871dm5m7mmldf6c7mx58fbdvk1ix5i3s9py82448gf";
  };

  checkInputs = [ nose coverage ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/metagriffin/globre";
    description = "A python glob-like regular expression generation library.";
    maintainers = with maintainers; [ glittershark ];
    license = licenses.gpl3;
  };
}
