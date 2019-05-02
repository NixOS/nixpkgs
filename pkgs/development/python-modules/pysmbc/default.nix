{ stdenv, buildPythonPackage, fetchPypi
, samba, pkgconfig
, setuptools }:

buildPythonPackage rec {
  version = "1.0.16";
  pname = "pysmbc";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.bz2";
    sha256 = "62199b5cca02c05d5f3b9edbc9a864fb8a2cbe47a465c0b9461642eb3b6f5aca";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ setuptools samba ];

  meta = with stdenv.lib; {
    description = "libsmbclient binding for Python";
    homepage = https://github.com/hamano/pysmbc;
    license = licenses.gpl2Plus;
  };
}
