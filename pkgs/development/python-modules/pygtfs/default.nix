{ lib
, buildPythonPackage
, docopt
, fetchPypi
, nose
, pytz
, pythonOlder
, setuptools-scm
, six
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "pygtfs";
  version = "0.1.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sGJwtf8DVIrE4hcU3IksnyAAt8yf67UBJIiVILDSsv8=";
  };

  postPatch = ''
    # https://github.com/jarondl/pygtfs/pull/72
    substituteInPlace setup.py \
      --replace "pytz>=2012d" "pytz"
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    docopt
    pytz
    six
    sqlalchemy
  ];

  nativeCheckInputs = [
    nose
  ];

  pythonImportsCheck = [
    "pygtfs"
  ];

  meta = with lib; {
    description = "Python module for GTFS";
    homepage = "https://github.com/jarondl/pygtfs";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
