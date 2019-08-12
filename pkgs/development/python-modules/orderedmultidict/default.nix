{ stdenv, buildPythonPackage, fetchPypi, flake8, six }:

buildPythonPackage rec {
  pname = "orderedmultidict";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bc2v0yflsxjyyjx4q9wqx0j3bvzcw9z87d5pz4iqac7bsxhn1q4";
  };

  checkInputs = [ flake8 ];

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Ordered Multivalue Dictionary.";
    homepage = https://github.com/gruns/orderedmultidict;
    license = licenses.publicDomain;
    maintainers = with maintainers; [ vanzef ];
  };
}
