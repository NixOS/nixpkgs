{ stdenv
, buildPythonPackage
, fetchFromGitHub
, six
, google_auth
}:

buildPythonPackage rec {
  pname = "google-cloud-testutils";
  version = "unstable-36ffa923c7037e8b4fdcaa76272cb6267e908a9d";

  # google-cloud-testutils is not "really"
  # released as a python package
  # but it is required for google-cloud-* tests
  # so why not package it as a module
  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    rev = "36ffa923c7037e8b4fdcaa76272cb6267e908a9d";
    sha256 = "1fvcnssmpgf4lfr7l9h7cz984rbc5mfr1j1br12japcib5biwzjy";
  };

  propagatedBuildInputs = [ six google_auth ];

  postPatch = ''
    cd test_utils
  '';

  meta = with stdenv.lib; {
    description = "System test utilities for google-cloud-python";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
