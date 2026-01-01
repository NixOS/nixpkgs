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
    sha256 = "38b9e61735a3161f9211a5773c5f5ea698f36af4ff7f77fa03e8d1ff0caa117f";
  };

  nativeCheckInputs = [ which ];
  propagatedBuildInputs = [ python-dateutil ];

  preInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i 's|^\([ ]*\)self.bin_path.*$|\1self.bin_path = "${pkgs.terminal-notifier}/bin/terminal-notifier"|' build/lib/pync/TerminalNotifier.py
  '';

<<<<<<< HEAD
  meta = {
    description = "Python Wrapper for Mac OS 10.8 Notification Center";
    homepage = "https://pypi.python.org/pypi/pync";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ lovek323 ];
=======
  meta = with lib; {
    description = "Python Wrapper for Mac OS 10.8 Notification Center";
    homepage = "https://pypi.python.org/pypi/pync";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ lovek323 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
