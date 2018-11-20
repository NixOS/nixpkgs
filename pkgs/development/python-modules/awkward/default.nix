{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  version = "0.4.4";
  pname = "awkward";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08ce07d564e381e70dd38c6bf241fa303b09b408b02db648ff91f354f01e7439";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with stdenv.lib; {
    homepage = https://github.com/scikit-hep/awkward-array;
    description = "Manipulate jagged, chunky, and/or bitmasked arrays as easily as Numpy";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
