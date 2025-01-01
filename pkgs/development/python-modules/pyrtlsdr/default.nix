{
  lib,
  buildPythonPackage,
  fetchPypi,
  rtl-sdr,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyrtlsdr";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+z5YO6BzuGHo4LxeYvZvBzZekUf102SR3krWLyPkU2I=";
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
    changelog = "https://github.com/pyrtlsdr/pyrtlsdr/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
