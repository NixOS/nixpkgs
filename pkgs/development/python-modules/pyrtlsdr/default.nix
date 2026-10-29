{
  lib,
  buildPythonPackage,
  fetchPypi,
  rtl-sdr,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyrtlsdr";
  version = "0.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-9fXB19nl+YCVwD8UMfLzm+RfVMweFwLMCJGr4Hsy5Ls=";
  };

  build-system = [ setuptools ];

  postPatch = ''
    sed "s|driver_files =.*|driver_files = ['${lib.getLib rtl-sdr}/lib/librtlsdr.so']|" -i rtlsdr/librtlsdr.py
  '';

  # No tests that can be used.
  doCheck = false;

  meta = {
    description = "Python wrapper for librtlsdr (a driver for Realtek RTL2832U based SDR's)";
    homepage = "https://github.com/roger-/pyrtlsdr";
    changelog = "https://github.com/pyrtlsdr/pyrtlsdr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bjornfor ];
  };
})
