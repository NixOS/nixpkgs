{ lib, buildPythonPackage, fetchFromGitHub, nose }:

buildPythonPackage rec {
  pname = "podcastparser";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "gpodder";
    repo = "podcastparser";
    rev = version;
    sha256 = "1s83iq0mxcikxv6gi003iyavl1ai3siw1d7arijh0g28l0fff23a";
  };

  nativeCheckInputs = [ nose ];

  checkPhase = ''
    nosetests test_*.py
  '';

  meta = {
    description = "podcastparser is a simple, fast and efficient podcast parser written in Python.";
    homepage = "http://gpodder.org/podcastparser/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mic92 ];
  };
}
