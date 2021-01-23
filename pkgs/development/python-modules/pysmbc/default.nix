{ lib, stdenv, buildPythonPackage, fetchPypi
, samba, pkg-config
, setuptools }:

buildPythonPackage rec {
  version = "1.0.21";
  pname = "pysmbc";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.bz2";
    sha256 = "14b75f358ical7zzqh3g1qkh2dxwxn2gz7sah5f5svndqkd3z8jy";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ setuptools samba ];

  meta = with lib; {
    description = "libsmbclient binding for Python";
    homepage = "https://github.com/hamano/pysmbc";
    license = licenses.gpl2Plus;
  };
}
