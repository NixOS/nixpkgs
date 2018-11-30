{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
}:

buildPythonPackage rec {
  pname = "Arpeggio";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a5258b84f76661d558492fa87e42db634df143685a0e51802d59cae7daad8732";
  };

  # Shall not be needed for next release
  LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  meta = {
    description = "Packrat parser interpreter";
    license = lib.licenses.mit;
  };
}
