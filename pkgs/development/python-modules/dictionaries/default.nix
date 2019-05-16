{ buildPythonPackage, fetchPypi, lib, six }:

buildPythonPackage rec {
  pname = "dictionaries";
  version = "0.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jx2ph509sk4l7spslz16y8l6xn97d13nspn4ds2lxn5ward9ihy";
  };

  buildInputs = [ six ];

  meta = {
    description = "Dict implementations with attribute access";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.MostAwesomeDude ];
  };
}
