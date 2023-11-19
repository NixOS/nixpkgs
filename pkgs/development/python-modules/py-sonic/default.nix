{ lib, buildPythonPackage, fetchPypi, isPy27 }:

buildPythonPackage rec {
  pname = "py-sonic";
  version = "1.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9ho0F5kf74pCsLujwLt+pU+Ikxu70/kk+WP7lnD7CiE=";
  };

  # package has no tests
  doCheck = false;
  pythonImportsCheck = [ "libsonic" ];

  meta = with lib; {
    homepage = "https://github.com/crustymonkey/py-sonic";
    description = "A python wrapper library for the Subsonic REST API";
    license = licenses.gpl3;
    maintainers = with maintainers; [ wenngle ];
  };
}
