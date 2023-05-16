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
<<<<<<< HEAD
  version = "0.30.0";
=======
  version = "0.29.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-O5BAfb+6fCbETaJmWsVSayTId/57VjA7U3FGCeNe28Y=";
=======
    hash = "sha256-kxrF/Msxjht7zGs0aEcL/Sf0qwcLiSoDPDUlE7Lrcmg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
