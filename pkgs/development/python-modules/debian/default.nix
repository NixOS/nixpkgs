{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, chardet
}:

buildPythonPackage rec {
  pname = "python-debian";
  version = "0.1.47";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UeICgjd3o9cWqEO4pUD7oroL7Z9QeofAwPnu/N7DNCw=";
  };

  propagatedBuildInputs = [
    chardet
  ];

  # No tests in archive
  doCheck = false;

  pythonImportsCheck = [
    "debian"
  ];

  meta = with lib; {
    description = "Debian package related modules";
    homepage = "https://salsa.debian.org/python-debian-team/python-debian";
    changelog = "https://salsa.debian.org/python-debian-team/python-debian/-/blob/master/debian/changelog";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
