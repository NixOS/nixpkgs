{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, chardet
}:

buildPythonPackage rec {
  pname = "python-debian";
  version = "0.1.44";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZVkv47ZPbGyT2U4tJZnbXgwigx07z/B8t7ltOECxMz4=";
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
