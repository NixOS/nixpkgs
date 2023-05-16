{ lib
, buildPythonPackage
, fetchPypi
, pythonRelaxDepsHook
, bleach
, bokeh
, param
, pyviz-comms
, markdown
, pyct
, requests
, setuptools
, tqdm
, typing-extensions
}:

buildPythonPackage rec {
  pname = "panel";
<<<<<<< HEAD
  version = "1.2.2";
=======
  version = "0.14.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "wheel";

  # We fetch a wheel because while we can fetch the node
  # artifacts using npm, the bundling invoked in setup.py
  # tries to fetch even more artifacts
  src = fetchPypi {
    inherit pname version format;
<<<<<<< HEAD
    hash = "sha256-RMRjxcUp6MTs001wdNfC/e6diOcgtqrSaVIOSQfPgTs=";
=======
    hash = "sha256-3U/PL8cnbNPw3xEM56YZesQEDXTE79yMCSsjdxwfUU0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "bokeh"
  ];

  propagatedBuildInputs = [
    bleach
    bokeh
    markdown
    param
    pyct
    pyviz-comms
    requests
    setuptools
    tqdm
    typing-extensions
  ];

  pythonImportsCheck = [
    "panel"
  ];

  # infinite recursion in test dependencies (hvplot)
  doCheck = false;

  meta = with lib; {
    description = "A high level dashboarding library for python visualization libraries";
    homepage = "https://github.com/holoviz/panel";
    changelog = "https://github.com/holoviz/panel/releases/tag/v${version}";
    license = licenses.bsd3;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
