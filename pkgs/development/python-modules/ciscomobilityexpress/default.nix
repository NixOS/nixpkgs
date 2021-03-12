{ buildPythonPackage, fetchPypi, lib, requests }:

buildPythonPackage rec {
  pname = "ciscomobilityexpress";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d8787245598e8371a83baa4db1df949d8a942c43f13454fa26ee3b09c3ccafc0";
  };

  propagatedBuildInputs = [ requests ];

  meta = {
    description = "Module to interact with Cisco Mobility Express APIs to fetch connected devices";
    homepage = "https://pypi.python.org/pypi/${pname}/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ uvnikita ];
  };
}
