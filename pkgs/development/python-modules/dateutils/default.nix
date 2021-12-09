{ lib, buildPythonPackage, fetchFromGitHub, python-dateutil, pytz }:

buildPythonPackage rec {
  pname = "dateutils";
  version = "0.6.12";

  src = fetchFromGitHub {
     owner = "jmcantrell";
     repo = "python-dateutils";
     rev = "v0.6.12";
     sha256 = "1qa48j7v23c65v8hxpjvi6a8qm08n8pj7g1m992r0qbvnyjx073z";
  };

  propagatedBuildInputs = [
    python-dateutil
    pytz
  ];

  pythonImportsCheck = [ "dateutils" ];

  meta = with lib; {
    description = "Utilities for working with datetime objects.";
    homepage = "https://github.com/jmcantrell/python-dateutils";
    license = licenses.bsd0;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
