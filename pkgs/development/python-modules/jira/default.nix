{ lib, buildPythonPackage, fetchPypi, isPy3k
, pytest, pytestrunner, pbr, glibcLocales , pytestcov
, requests, requests_oauthlib, requests_toolbelt, defusedxml }:

buildPythonPackage rec {
  pname = "jira";
  version = "1.0.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xncrcaqgj0gnva3bz5c4vwnn7z84v9cmr37pc93zx676w62fpm3";
  };

  buildInputs = [ glibcLocales pytest pytestcov pytestrunner pbr ];
  propagatedBuildInputs = [ requests requests_oauthlib requests_toolbelt defusedxml ];

  LC_ALL = "en_US.utf8";

  disabled = !isPy3k;

  # no tests in release tarball
  doCheck = false;

  meta = with lib; {
    description = "This library eases the use of the JIRA REST API from Python.";
    license = licenses.bsd2;
    maintainers = with maintainers; [ globin ];
  };
}
