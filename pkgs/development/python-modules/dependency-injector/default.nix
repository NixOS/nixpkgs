{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "dependency-injector";
  version = "3.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bmcgdfjavgxdzkb904q968ig1x44arvpj2m4rpm5nc9vhhgq43q";
  };

  # TODO: Enable tests after upstream merges https://github.com/ets-labs/python-dependency-injector/pull/204
  doCheck = false;

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Dependency injection microframework for Python";
    homepage = https://github.com/ets-labs/python-dependency-injector;
    license = licenses.bsd3;
    maintainers = with maintainers; [ gerschtli ];
  };
}
