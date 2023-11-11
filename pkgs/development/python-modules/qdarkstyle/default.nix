{ lib
, fetchPypi
, buildPythonPackage
, helpdev
, qtpy
}:

buildPythonPackage rec {
  pname = "qdarkstyle";
  version = "3.2.1";

  src = fetchPypi {
    inherit version;
    pname = "QDarkStyle";
    hash = "sha256-9VvQRcDHjkeOpaJTDzc5ovzqjL4DjkhprkUK4w/uw/c=";
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
