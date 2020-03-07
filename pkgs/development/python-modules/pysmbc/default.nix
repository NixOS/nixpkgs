{ stdenv, buildPythonPackage, fetchPypi
, samba, pkgconfig
, setuptools }:

buildPythonPackage rec {
  version = "1.0.18";
  pname = "pysmbc";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.bz2";
    sha256 = "5da8aef1e3edaaffb1fbe2afe3772ba0a5f5bf666a28ae5db7b59ef96e465bdf";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ setuptools samba ];

  meta = with stdenv.lib; {
    description = "libsmbclient binding for Python";
    homepage = https://github.com/hamano/pysmbc;
    license = licenses.gpl2Plus;
  };
}
