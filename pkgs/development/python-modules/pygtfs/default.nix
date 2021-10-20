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
  version = "0.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nx2idgza07kmvj7pcgpj3pqhw53v5rq63paw2ly51cjas2fv5pr";
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
