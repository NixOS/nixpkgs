{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,
}:

buildPythonPackage rec {
  pname = "py-sonic";
  version = "1.0.2";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GNjF7sW/5Mtbh0atpEVFt+M8XddNfedDVmxxOpDdIW4=";
  };

  # package has no tests
  doCheck = false;
  pythonImportsCheck = [ "libsonic" ];

  meta = with lib; {
    homepage = "https://github.com/crustymonkey/py-sonic";
    description = "Python wrapper library for the Subsonic REST API";
    license = licenses.gpl3;
    maintainers = with maintainers; [ wenngle ];
  };
}
