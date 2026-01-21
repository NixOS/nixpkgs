{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  python-dateutil,
  types-python-dateutil,
  pytestCheckHook,
  pytest-mock,
  pytz,
  simplejson,
}:

buildPythonPackage rec {
  pname = "arrow";
  version = "1.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7QzAUOmAAbh3noTUYbAJjErFl+iHBKZVWCsh0RblJtc=";
  };

  postPatch = ''
    # no coverage reports
    sed -i "/addopts/d" tox.ini
  '';

  nativeBuildInputs = [ flit-core ];

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
  disabledTests = [ "test_parse_tz_name_zzz" ];

  pythonImportsCheck = [ "arrow" ];

  meta = {
    description = "Python library for date manipulation";
    homepage = "https://github.com/crsmithdev/arrow";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
}
