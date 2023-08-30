{ lib
, buildPythonPackage
, factory_boy
, faker
, fetchPypi
, httpretty
, importlib-metadata
, inflection
, jsondate
, mock
, more-itertools
, numpy
, pandas
, parameterized
, pytestCheckHook
, python-dateutil
, pythonOlder
, requests
, six
}:

buildPythonPackage rec {
  pname = "quandl";
  version = "3.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "Quandl";
    hash = "sha256-bguC+8eGFhCzV3xTlyd8QiDgZe7g/tTkbNa2AhZVtkw=";
  };

  patches = [
    ./pandas2-datetime-removal.patch
  ];

  propagatedBuildInputs = [
    pandas
    numpy
    requests
    inflection
    python-dateutil
    six
    more-itertools
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    factory_boy
    faker
    httpretty
    jsondate
    mock
    parameterized
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "quandl"
  ];

  meta = with lib; {
    description = "Quandl Python client library";
    homepage = "https://github.com/quandl/quandl-python";
    changelog = "https://github.com/quandl/quandl-python/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ilya-kolpakov ];
  };
}
