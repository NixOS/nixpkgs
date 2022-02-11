{ lib, buildPythonPackage, fetchPypi, isPy27 }:

buildPythonPackage rec {
  pname = "py-sonic";
  version = "0.7.9";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1677b7287914567b5123de90ad872b441628d8a7777cf4a5f41671b813facf75";
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
