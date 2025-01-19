{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "1.0.2";
  format = "setuptools";
  pname = "pyfiglet";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dYeIAYq4+q3cCYTh6gX/Mw08ZL5mPFE8wfEF9qMGbas=";
  };

  doCheck = false;

  meta = {
    description = "FIGlet in pure Python";
    mainProgram = "pyfiglet";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
}
