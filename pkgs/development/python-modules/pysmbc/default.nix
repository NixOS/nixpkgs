{ stdenv, buildPythonPackage, fetchPypi
, samba, pkgconfig
, setuptools }:

buildPythonPackage rec {
  version = "1.0.21";
  pname = "pysmbc";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.bz2";
    sha256 = "5ea23fdac4cd6e5d5c814a9fff84edbc3701270e6f40fcffa18a4554862b6791";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ setuptools samba ];

  meta = with stdenv.lib; {
    description = "libsmbclient binding for Python";
    homepage = "https://github.com/hamano/pysmbc";
    license = licenses.gpl2Plus;
  };
}
