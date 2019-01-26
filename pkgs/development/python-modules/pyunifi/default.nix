{ stdenv, buildPythonPackage, fetchPypi
, requests }:

buildPythonPackage rec {
  pname = "pyunifi";
  version = "2.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf2f9f538722447bded6b319a35c26ea088c51ccdbd3dec887210946c7992ebf";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "API towards Ubiquity Networks UniFi controller";
    homepage = https://github.com/finish06/unifi-api;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
