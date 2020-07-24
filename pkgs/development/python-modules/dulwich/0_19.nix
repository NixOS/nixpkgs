{ stdenv, buildPythonPackage, fetchPypi
, urllib3, certifi
, gevent, geventhttpclient, mock, fastimport
, git, glibcLocales }:

buildPythonPackage rec {
  version = "0.19.16";
  pname = "dulwich";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f74561c448bfb6f04c07de731c1181ae4280017f759b0bb04fa5770aa84ca850";
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
