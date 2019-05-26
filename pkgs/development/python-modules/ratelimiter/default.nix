{
  stdenv
, buildPythonPackage
, fetchPypi
, pytest
, glibcLocales
}:

buildPythonPackage rec {
  pname = "ratelimiter";
  version = "1.2.0.post0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c395dcabdbbde2e5178ef3f89b568a3066454a6ddc223b76473dac22f89b4f7";
  };

  LC_ALL = "en_US.utf-8";

  nativeBuildInputs = [ glibcLocales ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test tests
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/RazerM/ratelimiter;
    license = licenses.asl20;
    description = "Simple python rate limiting object";
    maintainers = with maintainers; [ helkafen ];
  };
}

