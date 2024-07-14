{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "pyunifi";
  version = "2.21";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6nkZyu4Uq+dBAW2ON+lrxnpD4i93wHnlWWInPznb6k4=";
  };

  propagatedBuildInputs = [ requests ];

  meta = with lib; {
    description = "API towards Ubiquity Networks UniFi controller";
    homepage = "https://github.com/finish06/unifi-api";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
