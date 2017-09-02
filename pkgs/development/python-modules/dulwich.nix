{ stdenv, buildPythonPackage, fetchurl
, gevent, geventhttpclient, mock, fastimport
, git, glibcLocales }:

buildPythonPackage rec {
  version = "0.18.2";
  pname = "dulwich";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/d/dulwich/${name}.tar.gz";
    sha256 = "284d0000b21ac12f94bcd5eb3d7dcc42da51e5506b9a53a11c615b46da906d9b";
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
