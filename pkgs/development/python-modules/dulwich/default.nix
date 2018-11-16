{ stdenv, buildPythonPackage, fetchPypi
, urllib3, certifi
, gevent, geventhttpclient, mock, fastimport
, git, glibcLocales }:

buildPythonPackage rec {
  version = "0.19.6";
  pname = "dulwich";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9a7dc5c5759f3d3b7a9ac0a684aa2c47f099e1722d9caab5b043cef1d73ff4a2";
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
