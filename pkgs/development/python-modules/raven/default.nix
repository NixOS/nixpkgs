{ lib, buildPythonPackage, fetchurl, isPy3k, contextlib2 }:

buildPythonPackage rec {
  pname = "raven";
  version = "6.4.0";
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://pypi/r/raven/${name}.tar.gz";
    sha256 = "00m985w9fja2jf8dpvdhygcr26rwabxkgvcc2v5j6v7d6lrvpvdq";
  };

  # way too many dependencies to run tests
  # see https://github.com/getsentry/raven-python/blob/master/setup.py
  doCheck = false;

  propagatedBuildInputs = lib.optionals (!isPy3k) [ contextlib2 ];

  meta = {
    description = "A Python client for Sentry (getsentry.com)";
    homepage = https://github.com/getsentry/raven-python;
    license = [ lib.licenses.bsd3 ];
    maintainers = with lib.maintainers; [ primeos ];
  };
}
