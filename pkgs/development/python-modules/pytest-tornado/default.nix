{
  lib,
  buildPythonPackage,
  pytest,
  tornado,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pytest-tornado";
  version = "0.8.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ufoZMMMzud/im96Q+fQuZkMni10MlVKKgwKnRU/T8bE=";
  };

  # package has no tests
  doCheck = false;

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ tornado ];

  meta = with lib; {
    description = "Py.test plugin providing fixtures and markers to simplify testing of asynchronous tornado applications";
    homepage = "https://github.com/eugeniy/pytest-tornado";
    license = licenses.asl20;
  };
}
