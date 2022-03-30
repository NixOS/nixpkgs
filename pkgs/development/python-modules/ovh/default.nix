{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ovh";
  version = "1.0.0";

  # Needs yanc
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IQzwu0gwfPNPOLQLCO99KL5Hu2094Y+acQBFXVGzHhU=";
  };

  meta = {
    description = "Thin wrapper around OVH's APIs";
    homepage = "https://github.com/ovh/python-ovh";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.makefu ];
  };
}
