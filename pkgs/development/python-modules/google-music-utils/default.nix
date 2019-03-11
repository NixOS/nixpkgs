{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, audio-metadata, multidict, wrapt
, pytest
}:

buildPythonPackage rec {
  pname = "google-music-utils";
  version = "2.0.0";

  # Pypi tarball doesn't contain tests
  src = fetchFromGitHub {
    owner = "thebigmunch";
    repo = "google-music-utils";
    rev = version;
    sha256 = "0i5zcr1ypnxizi41s3lrplz9m9rmb56s5iihjx61kbybxcq2b6gk";
  };

  propagatedBuildInputs = [
    audio-metadata multidict wrapt
  ];

  checkInputs = [ pytest ];
  checkPhase = ''
    pytest
  '';

  disabled = pythonOlder "3.6";

  meta = with lib; {
    homepage = https://github.com/thebigmunch/google-music-utils;
    description = "A set of utility functionality for google-music and related projects";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
