{ lib, buildPythonPackage, fetchFromGitHub, nose }:

buildPythonPackage rec {
  pname = "podcastparser";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "gpodder";
    repo = "podcastparser";
    rev = version;
    sha256 = "10bk93fqsws360q1gkjvfzjda3351169zbr6v5lq9raa3mg1ln52";
  };

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests test_*.py
  '';

  meta = {
    description = "podcastparser is a simple, fast and efficient podcast parser written in Python.";
    homepage = http://gpodder.org/podcastparser/;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mic92 ];
  };
}
