{
  lib,
  buildPythonPackage,
  fetchPypi,
  rtl-sdr,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyrtlsdr";
  version = "0.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+z5YO6BzuGHo4LxeYvZvBzZekUf102SR3krWLyPkU2I=";
  };

  propagatedBuildInputs = [ setuptools ];

  postPatch = ''
    sed "s|driver_files =.*|driver_files = ['${lib.getLib rtl-sdr}/lib/librtlsdr.so']|" -i rtlsdr/librtlsdr.py
  '';

  # No tests that can be used.
  doCheck = false;

  meta = {
    description = "Python wrapper for librtlsdr (a driver for Realtek RTL2832U based SDR's)";
    homepage = "https://github.com/roger-/pyrtlsdr";
    changelog = "https://github.com/pyrtlsdr/pyrtlsdr/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bjornfor ];
  };
}
