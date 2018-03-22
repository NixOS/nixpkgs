{ lib, buildPythonPackage, fetchFromGitHub, nose }:

buildPythonPackage rec {
  pname = "podcastparser";
  version = "0.6.2";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "gpodder";
    repo = "podcastparser";
    rev = version;
    sha256 = "1mhg7192d6s1ll9mx1b63yfj6k4cnv4i95jllbnydyjv9ykkv0k1";
  };

  propagatedBuildInputs = [ ];

  buildInputs = [ nose ];

  checkPhase = "nosetests test_*.py";

  meta = {
    description = "podcastparser is a simple, fast and efficient podcast parser written in Python.";
    homepage = http://gpodder.org/podcastparser/;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mic92 ];
  };
}
