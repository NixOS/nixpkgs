{
  buildPythonPackage,
  fetchPypi,
  lib,
  matplotlib,
  pandas,
  poetry-core,
  pyqtree,
  tqdm,
}:

buildPythonPackage rec {
  pname = "pylabeladjust";
  version = "0.1.13";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-I8H5+AlsXH3p+nlnjOcpyjcwuI2XmZf6JOmcA3pI9Zs=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    pyqtree
    tqdm
    pandas
    matplotlib
  ];

  meta = {
    description = "Gephi's Label-Adjust algorithm ported to python";
    homepage = "https://github.com/MNoichl/pylabeladjust";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ hendrikheil ];
  };
}
