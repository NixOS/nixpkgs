{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  version = "4.0.0";
  pname = "ftputil";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d494c47f24fd3f8fbe92d40d90e0902c0e04288f200688af2b16d6b46fe441e1";
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
    homepage    = "http://ftputil.sschwarzer.net/";
    license     = licenses.bsd2; # "Modified BSD license, says pypi"
  };
}
