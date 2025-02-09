{ lib, buildPythonPackage, fetchPypi, enum34 }:

buildPythonPackage rec {
  pname = "enum-compat";
  version = "0.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3677daabed56a6f724451d585662253d8fb4e5569845aafa8bb0da36b1a8751e";
  };

  propagatedBuildInputs = [ enum34 ];

  meta = with lib; {
    homepage = "https://github.com/jstasiak/enum-compat";
    description = "enum/enum34 compatibility package";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
