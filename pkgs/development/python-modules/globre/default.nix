{ lib
, pythonAtLeast
, buildPythonPackage
, fetchPypi
, nose
, coverage
}:

buildPythonPackage rec {
  pname = "globre";
  version = "0.1.5";
  format = "setuptools";
  # https://github.com/metagriffin/globre/issues/7
  disabled = pythonAtLeast "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qhjpg0722871dm5m7mmldf6c7mx58fbdvk1ix5i3s9py82448gf";
  };

  nativeCheckInputs = [ nose coverage ];

  meta = with lib; {
    homepage = "https://github.com/metagriffin/globre";
    description = "A python glob-like regular expression generation library.";
    maintainers = with maintainers; [ glittershark ];
    license = licenses.gpl3;
  };
}
