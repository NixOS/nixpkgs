{ lib
, buildPythonPackage
, numpy
, fetchPypi
, fetchpatch
, raspberrypi-tools
}:
let
  pname = "picamera";
  version = "1.13";
  removeCustomInstallCommandPatch = fetchpatch {
    url = "https://github.com/waveform80/picamera/commit/c145015837caf512cdef777894b8c203998c1359.patch";
    sha256 = "0m9s3nrrqkalpywl8zjbcji1nbgf97c4biigil4v2gmpg4gc94b5";
  };
in
buildPythonPackage rec {
  inherit pname version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l1y2qda7ighgm00c8cqajwscwmqac4svlsxm6k5bn7406m1a249";
  };

  patches = [
    removeCustomInstallCommandPatch
  ];

  buildInputs = [ raspberrypi-tools ];
  propagatedBuildInputs = [ numpy ];

  meta = with lib; {
    description = "A pure Python interface to the Raspberry Pi camera module for Python 2.7 (or above) or Python 3.2 (or above).";
    homepage = "https://github.com/waveform80/picamera";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cpcloud ];
    platforms = [ "aarch64-linux" ];
  };
}
