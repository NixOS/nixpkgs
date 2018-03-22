{ lib, buildPythonPackage, fetchFromGitHub, isPy3k
, contextlib2, blinker
}:

buildPythonPackage rec {
  pname = "raven";
  version = "6.6.0";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "raven-python";
    rev = version;
    sha256 = "184wpr0zdcm260pxqll9kpmp2ywisn75k8pdm8gc6xmk740in1hj";
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
