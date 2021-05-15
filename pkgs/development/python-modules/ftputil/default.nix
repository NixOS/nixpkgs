{ stdenv, lib, buildPythonPackage, fetchPypi, pythonOlder, pytest, freezegun }:

buildPythonPackage rec {
  version = "5.0.1";
  pname = "ftputil";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "394997ccb3cd4825c6e22b5e349c62cf5016c35db4d60940f3513db66d205561";
  };

  checkInputs = [ pytest freezegun ];

  checkPhase = ''
    touch Makefile
    # Disable tests that require network access or access /home or assume execution before year 2020
    py.test test \
      -k "not test_public_servers and not test_real_ftp \
          and not test_set_parser and not test_repr \
          and not test_conditional_upload and not test_conditional_download_with_older_target \
  ''
  # need until https://ftputil.sschwarzer.net/trac/ticket/140#ticket is fixed
  + lib.optionalString stdenv.isDarwin "and not test_error_message_reuse"
  + ''"'';

  meta = with lib; {
    description = "High-level FTP client library (virtual file system and more)";
    homepage = "http://ftputil.sschwarzer.net/";
    license = licenses.bsd2; # "Modified BSD license, says pypi"
  };
}
