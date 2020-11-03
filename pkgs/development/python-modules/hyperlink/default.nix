{ lib, buildPythonPackage, fetchPypi, isPy27, idna, typing }:

buildPythonPackage rec {
  pname = "hyperlink";
  version = "20.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "47fcc7cd339c6cb2444463ec3277bdcfe142c8b1daf2160bdd52248deec815af";
  };

  requiredPythonModules = [ idna ]
    ++ lib.optionals isPy27 [ typing ];

  meta = with lib; {
    description = "A featureful, correct URL for Python";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ apeschar ];
  };
}
