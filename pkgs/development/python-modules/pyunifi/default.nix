{ stdenv, buildPythonPackage, fetchPypi
, requests }:

buildPythonPackage rec {
  pname = "pyunifi";
  version = "2.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0875b830db93ed3270aee38ea24d3da9328672f0c499f0e432c895e0b02eadc9";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "API towards Ubiquity Networks UniFi controller";
    homepage = https://github.com/finish06/unifi-api;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
