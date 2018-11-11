{ stdenv, buildPythonPackage, fetchPypi
, urllib3, certifi
, gevent, geventhttpclient, mock, fastimport
, git, glibcLocales }:

buildPythonPackage rec {
  version = "0.19.8";
  pname = "dulwich";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5743b4a7dddf105316c5bed75f4e97503d26f9b07e4c61044aa81b57322edf8e";
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
