{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "iniconfig";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s9z9n4603fdpv2vzh6ddzfgsjmb09n6qalkjl2xwrss6n4jzyg5";
  };

  doCheck = false; # avoid circular import with pytest
  pythonImportsCheck = [ "iniconfig" ];

  meta = with lib; {
    description = "brain-dead simple parsing of ini files";
    homepage = "https://github.com/CHANGE/iniconfig/";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
