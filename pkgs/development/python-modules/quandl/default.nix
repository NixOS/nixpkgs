{ lib, fetchPypi, buildPythonPackage, isPy3k, pythonOlder
# runtime dependencies
, pandas, numpy, requests, inflection, python-dateutil, six, more-itertools, importlib-metadata
# test suite dependencies
, nose, unittest2, flake8, httpretty, mock, jsondate, parameterized, faker, factory_boy
# additional runtime dependencies are required on Python 2.x
, pyopenssl, ndg-httpsclient, pyasn1
}:

buildPythonPackage rec {
  pname = "quandl";
  version = "3.6.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit version;
    pname = "Quandl";
    sha256 = "0jr69fqxhzdmkfh3fxz0yp2kks2hkmixrscjjf59q2l7irglwhc4";
  };

  checkInputs = [
    nose
    unittest2
    flake8
    httpretty
    mock
    jsondate
    parameterized
    faker
    factory_boy
  ];

  propagatedBuildInputs = [
    pandas
    numpy
    requests
    inflection
    python-dateutil
    six
    more-itertools
  ] ++ lib.optionals (!isPy3k) [
    pyopenssl
    ndg-httpsclient
    pyasn1
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  pythonImportsCheck = [ "quandl" ];

  meta = with lib; {
    description = "Quandl Python client library";
    homepage = "https://github.com/quandl/quandl-python";
    changelog = "https://github.com/quandl/quandl-python/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ilya-kolpakov ];
  };
}
