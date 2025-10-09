{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "1.0.4";
  format = "setuptools";
  pname = "pyfiglet";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-25yZQO0b8wSN7/U07VL/La+7ws12ELF7teyh321CeO8=";
  };

  doCheck = false;

  meta = with lib; {
    description = "FIGlet in pure Python";
    mainProgram = "pyfiglet";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
