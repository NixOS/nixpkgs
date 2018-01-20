{ lib, buildPythonPackage, fetchPypi, isPy3k, contextlib2, blinker }:

buildPythonPackage rec {
  pname = "raven";
  version = "6.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00m985w9fja2jf8dpvdhygcr26rwabxkgvcc2v5j6v7d6lrvpvdq";
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
