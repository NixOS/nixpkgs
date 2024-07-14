{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pyment";
  version = "0.3.3";
  format = "setuptools";

  src = fetchPypi {
    pname = "Pyment";
    inherit version;
    hash = "sha256-lRpMUtZ5HM7FW8c5gRFp7taZF9OHT1/nIoZmI6aX850=";
  };

  # Tests are not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/dadadel/pyment";
    description = "Create, update or convert docstrings in existing Python files, managing several styles";
    mainProgram = "pyment";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jethro ];
  };
}
