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
}:

buildPythonPackage rec {
  version = "0.20.25";
  pname = "dulwich";

  src = fetchPypi {
    inherit pname version;
    sha256 = "79baea81583eb61eb7bd4a819ab6096686b362c626a4640d84d4fc5539139353";
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
  ];

  doCheck = !stdenv.isDarwin;

  pythonImportsCheck = [ "dulwich" ];

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
