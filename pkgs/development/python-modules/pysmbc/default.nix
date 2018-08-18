{ stdenv, buildPythonPackage, fetchPypi
, samba, pkgconfig
, setuptools }:

buildPythonPackage rec {
  version = "1.0.15.8";
  pname = "pysmbc";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.bz2";
    sha256 = "07dzxfdqaj6zjg2rxxdww363bh8m02mcvgk47jw005cik9wc2rq5";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ setuptools samba ];

  meta = with stdenv.lib; {
    description = "libsmbclient binding for Python";
    homepage = https://github.com/hamano/pysmbc;
    license = licenses.gpl2Plus;
  };
}
