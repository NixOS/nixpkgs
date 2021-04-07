{ lib, buildPythonPackage, fetchPypi, isPy27, idna, typing ? null }:

buildPythonPackage rec {
  pname = "hyperlink";
  version = "21.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b";
  };

  propagatedBuildInputs = [ idna ]
    ++ lib.optionals isPy27 [ typing ];

  meta = with lib; {
    description = "A featureful, correct URL for Python";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ apeschar ];
  };
}
