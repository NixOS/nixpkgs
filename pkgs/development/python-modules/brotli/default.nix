{ lib, buildPythonPackage, fetchFromGitHub, pytest }:

buildPythonPackage rec {
  pname = "brotli";
  version = "1.0.9";

  # PyPI doesn't contain tests so let's use GitHub
  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xyp85h12sknl4pxg1x8lgx8simzhdv73h4a8c1m7gyslsny386g";
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
