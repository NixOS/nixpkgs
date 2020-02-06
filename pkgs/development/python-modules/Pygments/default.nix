{ lib
, buildPythonPackage
, fetchPypi
, docutils
}:

buildPythonPackage rec {
  pname = "Pygments";
  version = "2.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "98c8aa5a9f778fcd1026a17361ddaf7330d1b7c62ae97c3bb0ae73e0b9b6b0fe";
  };

  propagatedBuildInputs = [ docutils ];

  # Circular dependency with sphinx
  doCheck = false;

  meta = {
    homepage = https://pygments.org/;
    description = "A generic syntax highlighter";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ];
  };
}
