{ lib
, buildPythonPackage
, fetchPypi
, deprecated
, memestra
, python-lsp-server
}:

buildPythonPackage rec {
  pname = "pyls-memestra";
  version = "0.0.16";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zMVDd2uB4znw38z3yb0Nt7qQH5dGHTbQBIZO/qo1/t8=";
  };

  propagatedBuildInputs = [
    deprecated
    memestra
    python-lsp-server
  ];

  # Tests fail because they rely on writting to read-only files
  doCheck = false;

  pythonImportsCheck = [
    "pyls_memestra"
  ];

  meta = with lib; {
    description = "Memestra plugin for the Python Language Server";
    homepage = "https://github.com/QuantStack/pyls-memestra";
    license = licenses.bsd3;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
