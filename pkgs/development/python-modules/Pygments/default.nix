{ lib
, buildPythonPackage
, fetchPypi
, docutils
}:

buildPythonPackage rec {
  pname = "Pygments";
  version = "2.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15v2sqm5g12bqa0c7wikfh9ck2nl97ayizy1hpqhmws5gqalq748";
  };

  propagatedBuildInputs = [ docutils ];

  # Circular dependency with sphinx
  doCheck = false;

  meta = {
    homepage = http://pygments.org/;
    description = "A generic syntax highlighter";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ];
  };
}
