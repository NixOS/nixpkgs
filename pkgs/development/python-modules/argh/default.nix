{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, flit-core
, iocapture
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "argh";
<<<<<<< HEAD
  version = "0.29.3";
=======
  version = "0.28.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-WOQ4zpFpqqLm3hR+POs0zqz+JlVqIwb1Di1G9Sd5rLE=";
=======
    hash = "sha256-sgkwhvDoCaPswktkohRTCe6PVtA0k2zVnlfFWKNXMp0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    flit-core
  ];

  nativeCheckInputs = [
    iocapture
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "argh" ];

  meta = with lib; {
    changelog = "https://github.com/neithere/argh/blob/v${version}/CHANGES";
    homepage = "https://github.com/neithere/argh";
    description = "An unobtrusive argparse wrapper with natural syntax";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ domenkozar ];
  };
}
