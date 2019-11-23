{ lib, buildPythonPackage, fetchFromGitHub, pytest }:

buildPythonPackage rec {
  pname = "brotli";
  version = "1.0.7";

  # PyPI doesn't contain tests so let's use GitHub
  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "1811b55wdfg4kbsjcgh1kc938g118jpvif97ilgrmbls25dfpvvw";
  };

  dontConfigure = true;

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
