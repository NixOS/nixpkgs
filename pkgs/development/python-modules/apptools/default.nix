{ lib
, buildPythonPackage
, fetchPypi
, traitsui
, configobj
}:

buildPythonPackage rec {
  pname = "apptools";
  name = "apptools-${version}";
  version = "4.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "73f5c2344d8d36b81f164e9e576425749e91342cf9e8615f3d72627af0de86b7";
  };

  # No tests
  doCheck = false;

  propagatedBuildInputs = [ traitsui configobj ];

  meta = {
    description = "Application tools";
    homepage = https://docs.enthought.com/apptools;
    license = lib.licenses.bsd3;
  };
}