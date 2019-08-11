{ lib, buildPythonPackage, fetchPypi, isPy3k
, pytest, pytestrunner, pbr, glibcLocales , pytestcov
, requests, requests_oauthlib, requests_toolbelt, defusedxml
, ipython
}:

buildPythonPackage rec {
  pname = "jira";
  version = "2.0.0";

  PBR_VERSION = version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e2a94adff98e45b29ded030adc76103eab34fa7d4d57303f211f572bedba0e93";
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
