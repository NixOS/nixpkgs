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
, gpgme
, mock
, pkgs
, urllib3
, paramiko
, pythonOlder
}:

buildPythonPackage rec {
  version = "0.20.45";
  pname = "dulwich";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cHEN2coqRCGQx+UGiS2wdMMYrHYuIh91KbjONIAgQbc=";
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
    pkgs.gnupg
    mock
    paramiko
  ];

  doCheck = !stdenv.isDarwin;

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
