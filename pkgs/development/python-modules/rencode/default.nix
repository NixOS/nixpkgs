{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
}:

buildPythonPackage rec {
  pname = "rencode";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "aresch";
    repo = "rencode";
    rev = "v${version}";
    sha256 = "sha256-PGjjrZuoGYSPMNqXG1KXoZnOoWIe4g6s056jFhqrJ60=";
  };

  buildInputs = [ cython ];

  meta = with lib; {
    homepage = "https://github.com/aresch/rencode";
    description = "Fast (basic) object serialization similar to bencode";
    license = licenses.gpl3;
  };

}
