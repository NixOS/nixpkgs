{ stdenv, buildPythonPackage, fetchPypi
, samba, pkgconfig
, setuptools }:

buildPythonPackage rec {
  version = "1.0.21";
  pname = "pysmbc";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.bz2";
    sha256 = "14b75f358ical7zzqh3g1qkh2dxwxn2gz7sah5f5svndqkd3z8jy";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ setuptools samba ];

  meta = with stdenv.lib; {
    description = "libsmbclient binding for Python";
    homepage = "https://github.com/hamano/pysmbc";
    license = licenses.gpl2Plus;
  };
}
