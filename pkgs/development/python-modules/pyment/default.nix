{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pyment";
  version = "0.3.3";
  format = "setuptools";

  src = fetchPypi {
    pname = "Pyment";
    inherit version;
    sha256 = "951a4c52d6791ccec55bc739811169eed69917d3874f5fe722866623a697f39d";
  };

  # Tests are not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/dadadel/pyment";
    description = "Create, update or convert docstrings in existing Python files, managing several styles";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jethro ];
  };
}
