{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, flit-core
, python-dateutil
, types-python-dateutil
, pytestCheckHook
, pytest-mock
, pytz
, simplejson
}:

buildPythonPackage rec {
  pname = "arrow";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1FQGF2SMtfiVcw8a2MgqZfLa0BZvV7dfPKVHWcTWeoU=";
  };

  postPatch = ''
    # no coverage reports
    sed -i "/addopts/d" tox.ini
  '';

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    python-dateutil
    types-python-dateutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    pytz
    simplejson
  ];

  # ParserError: Could not parse timezone expression "America/Nuuk"
  disabledTests = [
    "test_parse_tz_name_zzz"
  ];

  pythonImportsCheck = [ "arrow" ];

  meta = with lib; {
    description = "Python library for date manipulation";
    homepage = "https://github.com/crsmithdev/arrow";
    license = licenses.asl20;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
