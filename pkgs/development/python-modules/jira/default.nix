{ lib, buildPythonPackage, fetchPypi, isPy3k
, pytest, pytestrunner, pbr, glibcLocales , pytestcov
, requests, requests_oauthlib, requests_toolbelt, defusedxml
, ipython
}:

buildPythonPackage rec {
  pname = "jira";
  version = "1.0.15";

  PBR_VERSION = version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "20108a1d5b0dd058d5d4e0047f2d09ee06aaa413b22ca4d5c249e86167417fe8";
  };

  buildInputs = [ glibcLocales pytest pytestcov pytestrunner pbr ];
  propagatedBuildInputs = [ requests requests_oauthlib requests_toolbelt defusedxml pbr ipython ];

  # impure tests because of connectivity attempts to jira servers
  doCheck = false;

  patches = [ ./sphinx-fix.patch ];

  LC_ALL = "en_US.utf8";

  disabled = !isPy3k;

  meta = with lib; {
    description = "This library eases the use of the JIRA REST API from Python.";
    license = licenses.bsd2;
    maintainers = with maintainers; [ globin ma27 ];
  };
}
