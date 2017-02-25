{ stdenv, buildPythonPackage, fetchurl
, gevent, geventhttpclient, mock, fastimport
, git, glibcLocales }:

buildPythonPackage rec {
  name = "dulwich-${version}";
  version = "0.14.1";

  src = fetchurl {
    url = "mirror://pypi/d/dulwich/${name}.tar.gz";
    sha256 = "14xsyxha6qyxxyf0ma3zv1sy31iy22vzwayk519n7a1gwzk4j7vw";
  };

  LC_ALL = "en_US.UTF-8";

  # Only test dependencies
  buildInputs = [ git glibcLocales gevent geventhttpclient mock fastimport ];

  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    description = "Simple Python implementation of the Git file formats and protocols";
    homepage = http://samba.org/~jelmer/dulwich/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ koral ];
  };
}
