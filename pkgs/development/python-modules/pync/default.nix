{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  python-dateutil,
  pkgs,
  which,
}:

buildPythonPackage rec {
  version = "2.0.3";
  pname = "pync";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OLnmFzWjFh+SEaV3PF9eppjzavT/f3f6A+jR/wyqEX8=";
  };

  nativeCheckInputs = [ which ];
  propagatedBuildInputs = [ python-dateutil ];

  preInstall = lib.optionalString stdenv.isDarwin ''
    sed -i 's|^\([ ]*\)self.bin_path.*$|\1self.bin_path = "${pkgs.terminal-notifier}/bin/terminal-notifier"|' build/lib/pync/TerminalNotifier.py
  '';

  meta = with lib; {
    description = "Python Wrapper for Mac OS 10.8 Notification Center";
    homepage = "https://pypi.python.org/pypi/pync";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ lovek323 ];
  };
}
