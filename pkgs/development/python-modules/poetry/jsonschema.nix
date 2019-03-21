{ lib, buildPythonPackage, fetchPypi, isPy27, callPackage
, attrs
, pyrsistent
, six
, functools32
, lockfile
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "jsonschema";
  version = "3.0.0a3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pkhsq91rhk6384p0jxjkhc9yml2ya2l0mysyq78sb4981h45n6z";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [
    attrs
    pyrsistent
    six
    lockfile
  ] ++ lib.optional isPy27 functools32;

  # tests for latest version rely on custom version of betterpaths that is
  # difficult to deal with and isn't used on master
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/Julian/jsonschema;
    description = "An implementation of JSON Schema validation for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
