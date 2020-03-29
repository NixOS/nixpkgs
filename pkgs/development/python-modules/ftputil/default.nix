{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  version = "3.4";
  pname = "ftputil";

  src = fetchPypi {
    inherit pname version;
    sha256 = "374b01e174079e91babe2a462fbd6f6c00dbfbfa299dec04239ca4229fbf8762";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    touch Makefile
    # Disable tests that require network access or access /home or assume execution before year 2020
    py.test test \
      -k "not test_public_servers and not test_real_ftp \
          and not test_set_parser and not test_repr \
          and not test_conditional_upload and not test_conditional_download_with_older_target"
  '';

  meta = with lib; {
    description = "High-level FTP client library (virtual file system and more)";
    homepage    = http://ftputil.sschwarzer.net/;
    license     = licenses.bsd2; # "Modified BSD license, says pypi"
  };
}
