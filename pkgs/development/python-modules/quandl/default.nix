{
  lib, fetchPypi, buildPythonPackage, isPy3k,
  # runtime dependencies
  pandas, numpy, requests, inflection, python-dateutil, six, more-itertools,
  # test suite dependencies
  nose, unittest2, flake8, httpretty, mock, jsondate, parameterized, faker, factory_boy,
  # additional runtime dependencies are required on Python 2.x
  pyOpenSSL ? null, ndg-httpsclient ? null, pyasn1 ? null
}:

buildPythonPackage rec {
  pname = "quandl";
  version = "3.5.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit version;
    pname = "Quandl";
    sha256 = "0zpw0nwqr4g56l9z4my0fahfgpcmfx74acbmv6nfx1dmq5ggraf3";
  };

  doCheck = true;

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
    pyOpenSSL
    ndg-httpsclient
    pyasn1
  ];

  meta = with lib; {
    description = "Quandl Python client library";
    homepage = "https://github.com/quandl/quandl-python";
    license = licenses.mit;
    maintainers = with maintainers; [ ilya-kolpakov ];
  };
}
