{ lib
, buildPythonPackage
, fetchPypi
, markdown
, isPy3k
, TurboCheetah
}:

buildPythonPackage rec {
  pname = "cheetah";
  version = "2.4.4";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550";
  };

  propagatedBuildInputs = [ markdown ];

  doCheck = false; # Circular dependency

  checkInputs = [
    TurboCheetah
  ];

  meta = {
    homepage = http://www.cheetahtemplate.org/;
    description = "A template engine and code generation tool";
    license = lib.licenses.mit;
  };
}