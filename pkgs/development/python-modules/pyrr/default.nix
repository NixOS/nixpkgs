{ stdenv, buildPythonPackage, fetchPypi
, setuptools, multipledispatch, numpy }:

buildPythonPackage rec {
  version = "0.10.1";
  pname = "pyrr";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06305b2f555f8b8091a6c29a05d5d33f131c9dd268e22d94985e43ab5df70c1d";
  };

  buildInputs = [ setuptools ];
  propagatedBuildInputs = [ multipledispatch numpy ];

  meta = with stdenv.lib; {
    description = "3D mathematical functions using NumPy";
    homepage = https://github.com/adamlwgriffiths/Pyrr/;
    license = licenses.bsd2;
  };
}
