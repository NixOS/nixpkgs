{
  lib,
  buildPythonPackage,
  factory-boy,
  fetchFromGitHub,
  httpretty,
  inflection,
  jsondate,
  mock,
  more-itertools,
  numpy,
  pandas,
  parameterized,
  pytestCheckHook,
  python-dateutil,
  requests,
  six,
}:

buildPythonPackage rec {
  pname = "nasdaq-data-link";
  version = "1.0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Nasdaq";
    repo = "data-link-python";
    tag = version;
    hash = "sha256-Q3Ay9FpJsvSVu0WU2bxFyo3ODKP/ZUo3SqsBtOGrIIE=";
  };

  propagatedBuildInputs = [
    inflection
    more-itertools
    numpy
    pandas
    python-dateutil
    requests
    six
  ];

  nativeCheckInputs = [
    factory-boy
    httpretty
    jsondate
    mock
    parameterized
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nasdaqdatalink" ];

  meta = {
    description = "Library for Nasdaq Data Link's RESTful API";
    homepage = "https://github.com/Nasdaq/data-link-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
