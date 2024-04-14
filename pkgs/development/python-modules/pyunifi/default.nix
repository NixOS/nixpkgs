{ lib, buildPythonPackage, fetchPypi
, requests }:

buildPythonPackage rec {
  pname = "pyunifi";
  version = "2.21";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ea7919caee14abe741016d8e37e96bc67a43e22f77c079e55962273f39dbea4e";
  };

  propagatedBuildInputs = [ requests ];

  meta = with lib; {
    description = "API towards Ubiquity Networks UniFi controller";
    homepage = "https://github.com/finish06/unifi-api";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
