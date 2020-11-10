{ stdenv, buildPythonPackage, fetchPypi
, urllib3, certifi
, gevent, geventhttpclient, mock, fastimport
, git, glibcLocales }:

buildPythonPackage rec {
  version = "0.20.5";
  pname = "dulwich";

  src = fetchPypi {
    inherit pname version;
    sha256 = "98484ede022da663c96b54bc8dcdb4407072cb50efd5d20d58ca4e7779931305";
  };

  LC_ALL = "en_US.UTF-8";

  propagatedBuildInputs = [ urllib3 certifi ];

  # Only test dependencies
  checkInputs = [ git glibcLocales gevent geventhttpclient mock fastimport ];

  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    description = "Simple Python implementation of the Git file formats and protocols";
    homepage = "https://samba.org/~jelmer/dulwich/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ koral ];
  };
}
