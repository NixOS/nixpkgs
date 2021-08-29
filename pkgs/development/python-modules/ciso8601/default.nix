{ lib
, buildPythonPackage
, fetchFromGitHub
, pytz
, unittest2
, isPy27
}:

buildPythonPackage rec {
  pname = "ciso8601";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "closeio";
    repo = "ciso8601";
    rev = "v${version}";
    sha256 = "0g1aiyc1ayh0rnibyy416m5mmck38ksgdm3jsy0z3rxgmgb24951";
  };

  checkInputs = [
    pytz
  ] ++ lib.optional (isPy27) unittest2;

  meta = with lib; {
    description = "Fast ISO8601 date time parser for Python written in C";
    homepage = "https://github.com/closeio/ciso8601";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
