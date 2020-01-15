{ stdenv, buildPythonPackage, fetchPypi
, requests }:

buildPythonPackage rec {
  pname = "pyunifi";
  version = "2.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d28ec8204fe3b0eb1043f5ba9b646a2c38e5fd89a0419d760cff8f0df507c83";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "API towards Ubiquity Networks UniFi controller";
    homepage = https://github.com/finish06/unifi-api;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
