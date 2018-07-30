{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ovh";
  version = "0.4.8";

  # Needs yanc
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "79fa4bdc61b9953af867676a9558d9e792b9fde568c980efe848a40565a217cd";
  };

  meta = {
    description = "Thin wrapper around OVH's APIs";
    homepage = http://api.ovh.com/;
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.makefu ];
  };
}