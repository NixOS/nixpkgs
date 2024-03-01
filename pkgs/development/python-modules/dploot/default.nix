{ lib
, buildPythonPackage
, poetry-core
, pythonRelaxDepsHook
, fetchPypi
, impacket
, cryptography
, pyasn1
, lxml
}:

buildPythonPackage rec {
  pname = "dploot";
  version = "2.2.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-40/5KOlEFvPL9ohCfR3kqoikpKFfJO22MToq3GhamKM=";
  };

  pythonRelaxDeps = true;

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    impacket
    cryptography
    pyasn1
    lxml
  ];

  pythonImportsCheck = [ "dploot" ];

  # No tests
  doCheck = false;

  meta = {
    homepage = "https://github.com/zblurx/dploot";
    description = "DPAPI looting remotely in Python";
    changelog = "https://github.com/zblurx/dploot/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vncsb ];
  };
}
