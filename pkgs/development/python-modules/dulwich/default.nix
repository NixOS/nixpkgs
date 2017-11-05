{ stdenv, buildPythonPackage, fetchurl
, gevent, geventhttpclient, mock, fastimport
, git, glibcLocales }:

buildPythonPackage rec {
  version = "0.18.4";
  pname = "dulwich";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/d/dulwich/${name}.tar.gz";
    sha256 = "b4baace48dde5e0a76f37b251c246c7e1829bda0617679f00cbade0e70a5ac5b";
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
