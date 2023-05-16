{ lib
<<<<<<< HEAD
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
, siobrultech-protocols
=======
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, siobrultech-protocols
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "greeneye-monitor";
<<<<<<< HEAD
  version = "5.0";
  format = "pyproject";

  disabled = pythonOlder "3.10";
=======
  version = "3.0.3";

  disabled = pythonOlder "3.5";

  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jkeljo";
    repo = "greeneye-monitor";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-HU+GWO08caKfQZ0tIDmJYAML4CKUM0CPukm7wD6uSEA=";
  };

  nativeBuildInputs = [
    setuptools
  ];
=======
    rev = "v${version}";
    hash = "sha256-weZTOVFBlB6TxFs8pLWfyB7WD/bn3ljBjX2tVi1Zc/I=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "siobrultech_protocols==" "siobrultech_protocols>="
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    aiohttp
    siobrultech-protocols
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "greeneye.monitor"
  ];

  meta = with lib; {
    description = "Receive data packets from GreenEye Monitor";
    homepage = "https://github.com/jkeljo/greeneye-monitor";
    changelog = "https://github.com/jkeljo/greeneye-monitor/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
=======
  pythonImportsCheck = [ "greeneye.monitor" ];

  meta = {
    description = "Receive data packets from GreenEye Monitor";
    homepage = "https://github.com/jkeljo/greeneye-monitor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
