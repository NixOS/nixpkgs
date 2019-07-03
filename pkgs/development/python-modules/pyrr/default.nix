{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
, multipledispatch
, numpy
}:

buildPythonPackage rec {
  version = "0.10.3";
  pname = "pyrr";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c0f7b20326e71f706a610d58f2190fff73af01eef60c19cb188b186f0ec7e1d";
  };

  buildInputs = [ setuptools ];
  propagatedBuildInputs = [ multipledispatch numpy ];

  meta = with stdenv.lib; {
    description = "3D mathematical functions using NumPy";
    homepage = https://github.com/adamlwgriffiths/Pyrr/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ c0deaddict ];
  };
}
