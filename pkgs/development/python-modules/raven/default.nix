{ lib, buildPythonPackage, fetchPypi, isPy3k, contextlib2, blinker }:

buildPythonPackage rec {
  pname = "raven";
  version = "6.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "84da75114739191bdf2388f296ffd6177e83567a7fbaf2701e034ad6026e4f3b";
  };

  # way too many dependencies to run tests
  # see https://github.com/getsentry/raven-python/blob/master/setup.py
  doCheck = false;

  propagatedBuildInputs = [ blinker ] ++ lib.optionals (!isPy3k) [ contextlib2 ];

  meta = {
    description = "A Python client for Sentry (getsentry.com)";
    homepage = https://github.com/getsentry/raven-python;
    license = [ lib.licenses.bsd3 ];
    maintainers = with lib.maintainers; [ primeos ];
  };
}
