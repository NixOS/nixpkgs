{ stdenv, buildPythonPackage, fetchPypi
, requests }:

buildPythonPackage rec {
  pname = "pyunifi";
  version = "2.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9439ffc992ce381a39d64b5e3f4460e53872faa9cca60dcf5cee94fc0eba7fca";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "API towards Ubiquity Networks UniFi controller";
    homepage = https://github.com/finish06/unifi-api;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
