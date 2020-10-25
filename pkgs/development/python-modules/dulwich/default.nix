{ stdenv, buildPythonPackage, fetchPypi
, urllib3, certifi
, gevent, geventhttpclient, mock, fastimport
, git, glibcLocales }:

buildPythonPackage rec {
  version = "0.20.6";
  pname = "dulwich";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e593f514b8ac740b4ceeb047745b4719bfc9f334904245c6edcb3a9d002f577b";
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
