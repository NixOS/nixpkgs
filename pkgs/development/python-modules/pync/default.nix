{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, dateutil
, pkgs
}:

buildPythonPackage rec {
  version  = "2.0.3";
  pname = "pync";
  disabled = ! isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "38b9e61735a3161f9211a5773c5f5ea698f36af4ff7f77fa03e8d1ff0caa117f";
  };

  buildInputs = [ pkgs.coreutils ];
  propagatedBuildInputs = [ dateutil ];

  preInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's|^\([ ]*\)self.bin_path.*$|\1self.bin_path = "${pkgs.terminal-notifier}/bin/terminal-notifier"|' build/lib/pync/TerminalNotifier.py
  '';

  meta = with stdenv.lib; {
    description = "Python Wrapper for Mac OS 10.8 Notification Center";
    homepage    = https://pypi.python.org/pypi/pync/1.4;
    license     = licenses.mit;
    platforms   = platforms.darwin;
    maintainers = with maintainers; [ lovek323 ];
  };

}
