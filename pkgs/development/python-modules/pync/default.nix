{ lib, stdenv
, buildPythonPackage
, fetchPypi
, python-dateutil
, pkgs
, which
}:

buildPythonPackage rec {
  version  = "2.0.3";
  pname = "pync";

  src = fetchPypi {
    inherit pname version;
    sha256 = "38b9e61735a3161f9211a5773c5f5ea698f36af4ff7f77fa03e8d1ff0caa117f";
  };

  checkInputs = [ which ];
  propagatedBuildInputs = [ python-dateutil ];

  preInstall = lib.optionalString stdenv.isDarwin ''
    sed -i 's|^\([ ]*\)self.bin_path.*$|\1self.bin_path = "${pkgs.terminal-notifier}/bin/terminal-notifier"|' build/lib/pync/TerminalNotifier.py
  '';

  meta = with lib; {
    description = "Python Wrapper for Mac OS 10.8 Notification Center";
    homepage    = "https://pypi.python.org/pypi/pync";
    license     = licenses.mit;
    platforms   = platforms.darwin;
    maintainers = with maintainers; [ lovek323 ];
  };

}
