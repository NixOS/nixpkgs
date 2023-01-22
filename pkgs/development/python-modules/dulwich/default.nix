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
, paramiko
, pytestCheckHook
, pythonOlder
, urllib3
}:

buildPythonPackage rec {
  version = "0.21.0";
  pname = "dulwich";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wizAXwIKlq012U1lIPgHAnC+4KN7V1aG0JwCeYsl7YY=";
  };

  LC_ALL = "en_US.UTF-8";

  propagatedBuildInputs = [
    certifi
    urllib3
  ];

  passthru.optional-dependencies = {
    fastimport = [
      fastimport
    ];
    pgp = [
      gpgme
      gnupg
    ];
    paramiko = [
      paramiko
    ];
  };

  nativeCheckInputs = [
    gevent
    geventhttpclient
    git
    glibcLocales
    pytestCheckHook
  ] ++ passthru.optional-dependencies.fastimport
  ++ passthru.optional-dependencies.pgp
  ++ passthru.optional-dependencies.paramiko;

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
    description = "Implementation of the Git file formats and protocols";
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
