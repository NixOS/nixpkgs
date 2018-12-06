{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  version = "0.3.0";
  pname = "awkward";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc3080c66987f2a03aa9ba0809e51227eb7aa34198da4b1ee4deb95356409693";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with stdenv.lib; {
    homepage = https://github.com/scikit-hep/awkward-array;
    description = "Manipulate jagged, chunky, and/or bitmasked arrays as easily as Numpy";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
