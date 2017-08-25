{ lib
, buildPythonPackage
, fetchPypi
, rtl-sdr
}:

buildPythonPackage rec {
  pname = "pyrtlsdr";
  version = "0.2.5";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd041143b68628c713c2227c78c40b0b4a0cb5d08df116f7bdc5f83c529be0e4";
  };

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
