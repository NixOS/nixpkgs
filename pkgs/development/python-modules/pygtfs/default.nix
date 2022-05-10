{ lib
, buildPythonPackage
, docopt
, fetchPypi
, nose
, pytz
, setuptools-scm
, six
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "pygtfs";
  version = "0.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sGJwtf8DVIrE4hcU3IksnyAAt8yf67UBJIiVILDSsv8=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    docopt
    pytz
    six
    sqlalchemy
  ];

  checkInputs = [
    nose
  ];

  pythonImportsCheck = [ "pygtfs" ];

  meta = with lib; {
    description = "Python module for GTFS";
    homepage = "https://github.com/jarondl/pygtfs";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
