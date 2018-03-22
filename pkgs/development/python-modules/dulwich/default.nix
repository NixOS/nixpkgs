{ stdenv, buildPythonPackage, fetchurl
, gevent, geventhttpclient, mock, fastimport
, git, glibcLocales }:

buildPythonPackage rec {
  version = "0.18.6";
  pname = "dulwich";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/d/dulwich/${name}.tar.gz";
    sha256 = "38a04406bc68315794c3bab37c7d4ed137fb8a839482d8894e72b0d9b3eb41a9";
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
