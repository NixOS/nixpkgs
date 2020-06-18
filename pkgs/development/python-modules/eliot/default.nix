{ lib
, buildPythonPackage
, fetchPypi
, zope_interface
, pyrsistent
, boltons
, cffi
, six
}:

let
  pname = "eliot";
  version = "1.12.0";

in buildPythonPackage {
  inherit pname version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "tuFtikOSysa9BzWKrvFAxQBZqwD8ExcQEoEOM+HZS3E=";
  };

  # Has a huge dependency graph for tests
  doCheck = false;

  propagatedBuildInputs = [
    zope_interface
    pyrsistent
    boltons
    cffi
    six
  ];

  meta = {
    description = "Eliot: the logging system that tells you *why* it happened.";
    homepage = "https://eliot.reathedocs.io";
    license = lib.licenses.asl20;
    maintainers = [  ];
  };

}
