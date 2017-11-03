{ lib, buildPythonPackage, fetchurl, isPy3k, contextlib2 }:

buildPythonPackage rec {
  name = "raven-6.3.0";

  src = fetchurl {
    url = "mirror://pypi/r/raven/${name}.tar.gz";
    sha256 = "1wgddbd092vih6k6mknp68vvm1pp12fikjqzglw6mnyw8njnbr7k";
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
