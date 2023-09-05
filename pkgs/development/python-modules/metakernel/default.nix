{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, ipykernel
, jedi
, jupyter-core
, pexpect
, pythonOlder
}:

buildPythonPackage rec {
  pname = "metakernel";
  version = "0.30.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-O5BAfb+6fCbETaJmWsVSayTId/57VjA7U3FGCeNe28Y=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    ipykernel
    jedi
    jupyter-core
    pexpect
  ];

  # Tests hang, so disable
  doCheck = false;

  pythonImportsCheck = [
    "metakernel"
  ];

  meta = with lib; {
    description = "Jupyter/IPython Kernel Tools";
    homepage = "https://github.com/Calysto/metakernel";
    changelog = "https://github.com/Calysto/metakernel/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ thomasjm ];
  };
}
