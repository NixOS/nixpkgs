{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  ipykernel,
  jedi,
  jupyter-core,
  pexpect,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "metakernel";
  version = "0.30.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SIWPiGMNsEcPIkcT0HY4/9QRt1wxPwYxZGLUOjywgug=";
  };

  build-system = [ hatchling ];

  dependencies = [
    ipykernel
    jedi
    jupyter-core
    pexpect
  ];

  # Tests hang, so disable
  doCheck = false;

  pythonImportsCheck = [ "metakernel" ];

<<<<<<< HEAD
  meta = {
    description = "Jupyter/IPython Kernel Tools";
    homepage = "https://github.com/Calysto/metakernel";
    changelog = "https://github.com/Calysto/metakernel/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ thomasjm ];
=======
  meta = with lib; {
    description = "Jupyter/IPython Kernel Tools";
    homepage = "https://github.com/Calysto/metakernel";
    changelog = "https://github.com/Calysto/metakernel/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ thomasjm ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
