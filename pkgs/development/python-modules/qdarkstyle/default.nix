{ lib
, fetchPypi
, buildPythonPackage
, helpdev
, qtpy
}:

buildPythonPackage rec {
  pname = "qdarkstyle";
  version = "3.2.3";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "QDarkStyle";
    hash = "sha256-DAt/dKbpISEAiZKzabq2BGgVfbHALNMNZKXpo7QC8a4=";
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
