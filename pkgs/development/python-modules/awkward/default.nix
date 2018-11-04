{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  version = "0.4.3";
  pname = "awkward";

  src = fetchPypi {
    inherit pname version;
    sha256 = "41cca910df0faaa30bb9a7682826f3d6f099cb1fd2af452f45a1dd99305db579";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with stdenv.lib; {
    homepage = https://github.com/scikit-hep/awkward-array;
    description = "Manipulate jagged, chunky, and/or bitmasked arrays as easily as Numpy";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
