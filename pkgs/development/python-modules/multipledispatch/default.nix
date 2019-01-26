{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "multipledispatch";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7ab1451fd0bf9b92cab3edbd7b205622fb767aeefb4fb536c2e3de9e0a38bea";
  };

  # No tests in archive
  doCheck = false;

  propagatedBuildInputs = [ six ];

  meta = {
    homepage = https://github.com/mrocklin/multipledispatch/;
    description = "A relatively sane approach to multiple dispatch in Python";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}