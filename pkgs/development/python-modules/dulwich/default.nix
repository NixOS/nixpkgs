{ lib
, stdenv
, buildPythonPackage
, certifi
, fastimport
, fetchPypi
, gevent
, geventhttpclient
, git
, glibcLocales
, gnupg
, gpgme
, mock
, urllib3
, paramiko
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  version = "0.20.46";
  pname = "dulwich";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Tw6I//9dsVI9k9kvFSX+X6FhMY/7qtUCwbmzvnoGcXI=";
  };

  LC_ALL = "en_US.UTF-8";

  propagatedBuildInputs = [
    certifi
    urllib3
  ];

  checkInputs = [
    fastimport
    gevent
    geventhttpclient
    git
    glibcLocales
    gpgme
    gnupg
    mock
    paramiko
    pytestCheckHook
  ];

  doCheck = !stdenv.isDarwin;

  disabledTests = [
    # OSError: [Errno 84] Invalid or incomplete multibyte or wide character: b'/build/tmpsqwlbpd1/\xc0'
    "test_no_decode_encode"
    # OSError: [Errno 84] Invalid or incomplete multibyte or wide character: b'/build/tmpwmtfyvo2/refs.git/refs/heads/\xcd\xee\xe2\xe0\xff\xe2\xe5\xf2\xea\xe01'
    "test_cyrillic"
    # OSError: [Errno 84] Invalid or incomplete multibyte or wide character: b'/build/tmpfseetobk/test/\xc0'
    "test_commit_no_encode_decode"
  ];

  disabledTestPaths = [
    # missing test inputs
    "dulwich/contrib/test_swift_smoke.py"
  ];

  pythonImportsCheck = [
    "dulwich"
  ];

  meta = with lib; {
    description = "Simple Python implementation of the Git file formats and protocols";
    longDescription = ''
      Dulwich is a Python implementation of the Git file formats and protocols, which
      does not depend on Git itself. All functionality is available in pure Python.
    '';
    homepage = "https://www.dulwich.io/";
    changelog = "https://github.com/dulwich/dulwich/blob/dulwich-${version}/NEWS";
    license = with licenses; [ asl20 gpl2Plus ];
    maintainers = with maintainers; [ koral ];
  };
}
