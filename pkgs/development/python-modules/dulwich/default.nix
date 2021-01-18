{ lib, stdenv, buildPythonPackage, fetchPypi
, urllib3, certifi
, gevent, geventhttpclient, mock, fastimport
, git, glibcLocales }:

buildPythonPackage rec {
  version = "0.20.14";
  pname = "dulwich";

  src = fetchPypi {
    inherit pname version;
    sha256 = "21d6ee82708f7c67ce3fdcaf1f1407e524f7f4f7411a410a972faa2176baec0d";
  };

  LC_ALL = "en_US.UTF-8";

  propagatedBuildInputs = [ urllib3 certifi ];

  # Only test dependencies
  checkInputs = [ git glibcLocales gevent geventhttpclient mock fastimport ];

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Simple Python implementation of the Git file formats and protocols";
    homepage = "https://samba.org/~jelmer/dulwich/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ koral ];
  };
}
