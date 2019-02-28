{ stdenv, buildPythonPackage, fetchPypi
, requests }:

buildPythonPackage rec {
  pname = "pyunifi";
  version = "2.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10vwa3gz1y6gc3bij14sv1gqxhx28svajnrz0jqhwfzy0j1fqa0x";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "API towards Ubiquity Networks UniFi controller";
    homepage = https://github.com/finish06/unifi-api;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
