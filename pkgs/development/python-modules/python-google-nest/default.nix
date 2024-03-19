{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests-oauthlib
}:

buildPythonPackage rec {
  pname = "python-google-nest";
  version = "5.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qL4Qk2NW41Sb9raF0vnEb04w3uyaWPauDnNY+DvnNgQ=";
  };

  propagatedBuildInputs = [
    requests-oauthlib
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "nest"
  ];

  meta = with lib; {
    description = "Python API and command line tool for talking to Nest thermostats";
    homepage = "https://github.com/axlan/python-nest/";
    license = licenses.cc-by-nc-sa-30;
    maintainers = with maintainers; [ fab ];
  };
}
