{ stdenv, buildPythonPackage, fetchurl
, gevent, geventhttpclient, mock, fastimport
, git, glibcLocales }:

buildPythonPackage rec {
  version = "0.17.3";
  pname = "dulwich";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/d/dulwich/${name}.tar.gz";
    sha256 = "0c3eccac93823e172b05d57aaeab3d6f03c6c0f1867613606d1909a3ab4100ca";
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
