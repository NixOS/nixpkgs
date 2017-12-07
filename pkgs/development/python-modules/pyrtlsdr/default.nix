{ lib
, buildPythonPackage
, fetchPypi
, rtl-sdr
, pypandoc
, pandoc
}:

buildPythonPackage rec {
  pname = "pyrtlsdr";
  version = "0.2.7";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7942fe2e7821d09206002ea7e820e694094b3f964885123eb6eee1167f39b8da";
  };

  buildInputs = [ pypandoc pandoc ];

  postPatch = ''
    sed "s|driver_files =.*|driver_files = ['${rtl-sdr}/lib/librtlsdr.so']|" -i rtlsdr/librtlsdr.py
  '';

  # No tests that can be used.
  doCheck = false;

  meta = with lib; {
    description = "Python wrapper for librtlsdr (a driver for Realtek RTL2832U based SDR's)";
    homepage = https://github.com/roger-/pyrtlsdr;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor ];
 };
}
