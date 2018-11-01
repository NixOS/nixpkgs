{ lib, buildPythonPackage, fetchFromGitHub, pytest }:

buildPythonPackage rec {
  pname = "brotli";
  version = "1.0.5";

  # PyPI doesn't contain tests so let's use GitHub
  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ssj7mnhpdpk7qnwr49qfd4gxhkmvbli5mhs274pz55cx1xp7xja";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest python/tests
  '';

  meta = {
    homepage = https://github.com/google/brotli;
    description = "Generic-purpose lossless compression algorithm";
    license = lib.licenses.mit;
  };
}
