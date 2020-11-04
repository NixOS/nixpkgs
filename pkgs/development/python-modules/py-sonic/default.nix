{ lib, buildPythonPackage, fetchPypi, isPy27 }:

buildPythonPackage rec {
  pname = "py-sonic";
  version = "0.7.7";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4cea42a2b0dc2ed0fd8568d6bf0509cfa2675a8b1c347ce9364a00881ebc0272";
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
