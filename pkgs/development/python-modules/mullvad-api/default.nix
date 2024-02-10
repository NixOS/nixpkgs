{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "mullvad-api";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "mullvad_api";
    inherit version;
    sha256 = "0r0hc2d6vky52hxdqxn37w0y42ddh1zal6zz2cvqlxamc53wbiv1";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "mullvad_api" ];

  meta = with lib; {
    description = "Python client for the Mullvad API";
    homepage = "https://github.com/meichthys/mullvad-api";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
