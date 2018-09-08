{
  lib, fetchFromGitHub, buildPythonPackage, isPy3k,
  # runtime dependencies
  pandas, numpy, requests, inflection, python-dateutil, six, more-itertools,
  # test suite dependencies
  nose, unittest2, flake8, httpretty, mock, factory_boy, jsondate,
  # additional runtime dependencies are required on Python 2.x
  pyOpenSSL ? null, ndg-httpsclient ? null, pyasn1 ? null
}:

buildPythonPackage rec {
  pname = "quandl";
  version = "3.2.1";
  sha256 = "0vc0pzs2px9yaqkqcmd2m1b2bq1iils8fs0xbl0989hjq791a4jr";

  patches = [ ./allow-requests-v2.18.patch ];

  # Tests do not work with fetchPypi
  src = fetchFromGitHub {
    owner = pname;
    repo = "quandl-python";
    rev = "refs/tags/v${version}";
    inherit sha256;
    fetchSubmodules = true; # Fetching by tag does not work otherwise
  };

  doCheck = true;

  checkInputs = [
    nose
    unittest2
    flake8
    httpretty
    mock
    factory_boy
    jsondate
  ];

  propagatedBuildInputs = [
    pandas
    numpy
    requests
    inflection
    python-dateutil
    six
    more-itertools
  ] ++ lib.optional (!isPy3k) [
    pyOpenSSL
    ndg-httpsclient
    pyasn1
  ];

  meta = {
    homepage = https://github.com/quandl/quandl-python;
    description = "Quandl Python client library";
    maintainers = [ lib.maintainers.ilya-kolpakov ];
    license = lib.licenses.mit;
  };
}
