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
, mock
, urllib3
}:

buildPythonPackage rec {
  version = "0.20.20";
  pname = "dulwich";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QmlZuXBfrcxsgg5a3zKR1xpIq6CvzPdBFCLjMI8RX4c=";
  };

  LC_ALL = "en_US.UTF-8";

  propagatedBuildInputs = [ urllib3 certifi ];

  # Only test dependencies
  checkInputs = [ git glibcLocales gevent geventhttpclient mock fastimport ];

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
