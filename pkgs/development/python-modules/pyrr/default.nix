{ stdenv, buildPythonPackage, fetchPypi
, setuptools, multipledispatch, numpy }:

buildPythonPackage rec {
  version = "0.7.2";
  pname = "pyrr";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04a65a9fb5c746b41209f55b21abf47a0ef80a4271159d670ca9579d9be3b4fa";
  };

  buildInputs = [ setuptools ];
  propagatedBuildInputs = [ multipledispatch numpy ];

  meta = with stdenv.lib; {
    description = "3D mathematical functions using NumPy";
    homepage = https://github.com/adamlwgriffiths/Pyrr/;
    license = licenses.bsd2;
  };
}
