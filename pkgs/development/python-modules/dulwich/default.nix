{ stdenv, buildPythonPackage, fetchPypi
, urllib3, certifi
, gevent, geventhttpclient, mock, fastimport
, git, glibcLocales }:

buildPythonPackage rec {
  version = "0.19.10";
  pname = "dulwich";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0330787f28c5252f12040b9a1c0f5990f19f806c12b3d510ee7ea1fa53a6f3b4";
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
