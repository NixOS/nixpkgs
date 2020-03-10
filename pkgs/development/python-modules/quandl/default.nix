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
  version = "3.4.8";

  src = fetchPypi {
    inherit version;
    pname = "Quandl";
    sha256 = "179knz21filz6x6qk66b7dk2pj1x4jnvxxd5x71ap19f367dkkb3";
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

  meta = {
    homepage = "https://github.com/quandl/quandl-python";
    description = "Quandl Python client library";
    maintainers = [ lib.maintainers.ilya-kolpakov ];
    license = lib.licenses.mit;
  };
}
