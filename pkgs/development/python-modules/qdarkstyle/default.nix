{ lib
, fetchPypi
, buildPythonPackage
, helpdev
, qtpy
}:

buildPythonPackage rec {
  pname = "qdarkstyle";
  version = "3.2";

  src = fetchPypi {
    inherit version;
    pname = "QDarkStyle";
    hash = "sha256-8vA8S9f7Th6H+PXSM8eDkWVCL0PWeXy+AOC9kZRJ8Sw=";
  };

  # No tests available
  doCheck = false;

  propagatedBuildInputs = [ helpdev qtpy ];

  meta = with lib; {
    description = "A dark stylesheet for Python and Qt applications";
    homepage = "https://github.com/ColinDuquesnoy/QDarkStyleSheet";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
