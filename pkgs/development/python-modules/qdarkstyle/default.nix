{
  lib,
  fetchPypi,
  buildPythonPackage,
  helpdev,
  qtpy,
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

  propagatedBuildInputs = [
    helpdev
    qtpy
  ];

<<<<<<< HEAD
  meta = {
    description = "Dark stylesheet for Python and Qt applications";
    homepage = "https://github.com/ColinDuquesnoy/QDarkStyleSheet";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nyanloutre ];
=======
  meta = with lib; {
    description = "Dark stylesheet for Python and Qt applications";
    homepage = "https://github.com/ColinDuquesnoy/QDarkStyleSheet";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
