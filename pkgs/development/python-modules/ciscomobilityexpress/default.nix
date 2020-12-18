{ buildPythonPackage, fetchPypi, lib, requests }:

buildPythonPackage rec {
  pname = "ciscomobilityexpress";
  version = "0.3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kj0i1963afxqw9apk0yxzj1f7kpi1949ggnkzkb8v90kxpgymma";
  };

  propagatedBuildInputs = [ requests ];

  meta = {
    description = "Module to interact with Cisco Mobility Express APIs to fetch connected devices";
    homepage = "https://pypi.python.org/pypi/${pname}/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ uvnikita ];
  };
}
