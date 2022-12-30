{ lib
, fetchPypi
, buildPythonPackage
, urllib3
, geojson
, isPy3k
, sqlalchemy
, pytestCheckHook
, pytz
, stdenv
}:

buildPythonPackage rec {
  pname = "crate";
  version = "0.29.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SywW/b4DnVeSzzRiHbDaKTjcuwDnkwrK6vFfaQVIZhQ=";
  };

  propagatedBuildInputs = [
    urllib3
    sqlalchemy
    geojson
  ];

  checkInputs = [
    pytestCheckHook
    pytz
  ];

  disabledTests = [
    # network access
    "test_layer_from_uri"
  ];

  disabledTestPaths = [
    # imports setuptools.ssl_support, which doesn't exist anymore
    "src/crate/client/test_http.py"
  ];

  meta = with lib; {
    homepage = "https://github.com/crate/crate-python";
    description = "A Python client library for CrateDB";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
  };
}
