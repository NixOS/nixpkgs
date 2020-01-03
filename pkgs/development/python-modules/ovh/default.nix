{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ovh";
  version = "0.5.0";

  # Needs yanc
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f74d190c4bff0953d76124cb8ed319a8a999138720e42957f0db481ef4746ae8";
  };

  meta = {
    description = "Thin wrapper around OVH's APIs";
    homepage = https://github.com/ovh/python-ovh;
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.makefu ];
  };
}
