{ lib, buildPythonPackage, fetchFromGitHub, nose }:

buildPythonPackage rec {
  pname = "podcastparser";
  version = "0.6.1";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "gpodder";
    repo = "podcastparser";
    rev = version;
    sha256 = "0q3qc8adykmm692ha0c37xd6wbj830zlq900fyw6vrfan9bgdj5y";
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
