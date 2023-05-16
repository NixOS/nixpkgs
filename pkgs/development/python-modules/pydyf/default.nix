{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, ghostscript
, pillow
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pydyf";
<<<<<<< HEAD
  version = "0.7.0";
=======
  version = "0.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-paiMsG5b62Sh7yFH7oebDlE59f24J/2i/PFKAYx7EeY=";
=======
    hash = "sha256-UedRrhUEA3wfwfSBURkTewEYAs1fbDU52wZsRVsUp+E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--isort --flake8 --cov --no-cov-on-fail" ""
  '';

  nativeBuildInputs = [
    flit-core
  ];

  nativeCheckInputs = [
    ghostscript
    pillow
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pydyf"
  ];

  meta = with lib; {
    description = "Low-level PDF generator written in Python and based on PDF specification 1.7";
    homepage = "https://doc.courtbouillon.org/pydyf/stable/";
<<<<<<< HEAD
    changelog = "https://github.com/CourtBouillon/pydyf/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = with maintainers; [ rprecenth ];
  };
}
