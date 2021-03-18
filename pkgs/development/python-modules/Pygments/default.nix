{ lib
, buildPythonPackage
, fetchPypi
, docutils
}:

buildPythonPackage rec {
  pname = "Pygments";
  version = "2.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "153zyxigm879sk2n71lfv03y2pgxb7dl0dlsbwkz9aydxnkf2mi6";
  };

  propagatedBuildInputs = [ docutils ];

  # Circular dependency with sphinx
  doCheck = false;
  pythonImportsCheck = [ "pygments" ];

  meta = {
    homepage = "https://pygments.org/";
    description = "A generic syntax highlighter";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ];
  };
}
