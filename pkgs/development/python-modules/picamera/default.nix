{ lib
, buildPythonPackage
, numpy
, fetchPypi
}:
let
  pname = "picamera";
  version = "1.13";
in
buildPythonPackage rec {
  inherit pname version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l1y2qda7ighgm00c8cqajwscwmqac4svlsxm6k5bn7406m1a249";
  };

  patches = [
    https://github.com/waveform80/picamera/commit/c145015837caf512cdef777894b8c203998c1359.patch
  ];
  propagatedBuildInputs = [ numpy ];

  meta = with lib; {
    description = "A pure Python interface to the Raspberry Pi camera module for Python 2.7 (or above) or Python 3.2 (or above).";
    homepage = "https://github.com/waveform80/picamera";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cpcloud ];
    platforms = [ "aarch64-linux" ];
  };
}
