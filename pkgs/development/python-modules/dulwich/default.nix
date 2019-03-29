{ stdenv, buildPythonPackage, fetchPypi
, urllib3, certifi
, gevent, geventhttpclient, mock, fastimport
, git, glibcLocales }:

buildPythonPackage rec {
  version = "0.19.11";
  pname = "dulwich";

  src = fetchPypi {
    inherit pname version;
    sha256 = "afbe070f6899357e33f63f3f3696e601731fef66c64a489dea1bc9f539f4a725";
  };

  LC_ALL = "en_US.UTF-8";

  propagatedBuildInputs = [ urllib3 certifi ];

  # Only test dependencies
  checkInputs = [ git glibcLocales gevent geventhttpclient mock fastimport ];

  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    description = "Simple Python implementation of the Git file formats and protocols";
    homepage = https://samba.org/~jelmer/dulwich/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ koral ];
  };
}
