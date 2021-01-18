{ buildPythonPackage, fetchPypi, lib, requests }:

buildPythonPackage rec {
  pname = "ciscomobilityexpress";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd3fe893d8a44f5ac1d46580af88e07f1066e73744763aca4ef2226f87d575ff";
  };

  propagatedBuildInputs = [ requests ];

  meta = {
    description = "Module to interact with Cisco Mobility Express APIs to fetch connected devices";
    homepage = "https://pypi.python.org/pypi/${pname}/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ uvnikita ];
  };
}
