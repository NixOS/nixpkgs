{ stdenv, buildPythonPackage, fetchPypi
, samba, pkgconfig
, setuptools }:

buildPythonPackage rec {
  version = "1.0.19";
  pname = "pysmbc";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.bz2";
    sha256 = "0dwffbfp3ay8y35hhc37ip61xdh522f5rfs097f3ia121h9x1mvj";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ setuptools samba ];

  meta = with stdenv.lib; {
    description = "libsmbclient binding for Python";
    homepage = "https://github.com/hamano/pysmbc";
    license = licenses.gpl2Plus;
  };
}
