{ lib
, buildPythonPackage
, fetchPypi
, docutils
}:

buildPythonPackage rec {
  pname = "Pygments";
  version = "2.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6";
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
