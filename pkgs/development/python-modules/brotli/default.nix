{ lib, buildPythonPackage, fetchFromGitHub, pytest }:

buildPythonPackage rec {
  pname = "brotli";
  version = "1.0.9";

  # PyPI doesn't contain tests so let's use GitHub
  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rdp9rx197q467ixp53g4cgc3jbsdaxr62pz0a8ayv2lvm944azh";
    # for some reason, the test data isn't captured in releases, force a git checkout
    deepClone = true;
  };

  dontConfigure = true;

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest python/tests
  '';

  meta = {
    homepage = "https://github.com/google/brotli";
    description = "Generic-purpose lossless compression algorithm";
    license = lib.licenses.mit;
  };
}
