{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "pytzdata";
  version = "2020.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PvoTszWgCo3h00WuQex43RHJ+IB/Ui05hQ8t2ChoFUA=";
  };

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Timezone database for Python";
    homepage = "https://github.com/sdispater/pytzdata";
    license = licenses.mit;
  };
}
