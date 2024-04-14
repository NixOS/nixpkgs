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
  version = "0.30.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Siff2FO4SfASgkLFUgTuWXpajYZClPJghLry+8gU1aQ=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
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
