{ lib, buildPythonPackage, fetchPypi, isPy27
, attrs
, pyrsistent
, six
, functools32
, lockfile
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "jsonschema";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8d4a2b7b6c2237e0199c8ea1a6d3e05bf118e289ae2b9d7ba444182a2959560d";
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
