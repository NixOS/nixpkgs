{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, rtl-sdr
, setuptools
}:

buildPythonPackage rec {
  pname = "pyrtlsdr";
  version = "0.2.93";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LeKbtOQDcIinjokBK8LMhLc9xFxgYIsot9kD9ikjuiY=";
  };

  propagatedBuildInputs = [ setuptools ];

  postPatch = ''
    sed "s|driver_files =.*|driver_files = ['${rtl-sdr}/lib/librtlsdr.so']|" -i rtlsdr/librtlsdr.py
  '';

  # No tests that can be used.
  doCheck = false;

  meta = with lib; {
    description = "Python wrapper for librtlsdr (a driver for Realtek RTL2832U based SDR's)";
    homepage = "https://github.com/roger-/pyrtlsdr";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
