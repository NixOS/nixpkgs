{ stdenv, buildPythonPackage, fetchPypi
, requests }:

buildPythonPackage rec {
  pname = "pyunifi";
  version = "2.20.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b52d1b0d87365fcfed8572b5dbd8d675bffece4ab3484bf083863f278c727d3d";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "API towards Ubiquity Networks UniFi controller";
    homepage = "https://github.com/finish06/unifi-api";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
