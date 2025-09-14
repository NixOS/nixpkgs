{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "1.0.3";
  format = "setuptools";
  pname = "pyfiglet";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-utO1XS7Msw1Gk8z9lFc8KjR33XX4ag5UZc6lG9v+KHU=";
  };

  doCheck = false;

  meta = {
    description = "FIGlet in pure Python";
    mainProgram = "pyfiglet";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
}
