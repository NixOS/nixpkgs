{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, chardet
}:

buildPythonPackage rec {
  pname = "python-debian";
  version = "0.1.43";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "abc702511c4e268da49c22fd97c83de355c559f3271e0798a6b67964be3d8248";
  };

  propagatedBuildInputs = [ chardet ];

  # No tests in archive
  doCheck = false;

  pythonImportsCheck = [ "debian" ];

  meta = with lib; {
    description = "Debian package related modules";
    homepage = "https://salsa.debian.org/python-debian-team/python-debian";
    changelog = "https://salsa.debian.org/python-debian-team/python-debian/-/blob/master/debian/changelog";
    license = licenses.gpl2;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
