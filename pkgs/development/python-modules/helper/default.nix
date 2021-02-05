{ lib, buildPythonPackage, fetchPypi, pyyaml, mock }:

buildPythonPackage rec {
  pname = "helper";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4af39471d25c8820f505bc5c5b1447878bdbec0781c60d73d9ffbdf5383152b4";
  };

  checkInputs = [ mock ];
  propagatedBuildInputs = [ pyyaml ];

  # No tests in the pypi tarball
  doCheck = false;

  meta = with lib; {
    description = "Development library for quickly writing configurable applications and daemons";
    homepage = "https://helper.readthedocs.org/";
    license = licenses.bsd3;
  };
}
