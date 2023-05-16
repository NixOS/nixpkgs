{ lib
, buildPythonPackage
, fetchPypi
, argcomplete
, colorama
, jmespath
, pygments
, pyyaml
, six
, tabulate
, mock
, vcrpy
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "knack";
<<<<<<< HEAD
  version = "0.11.0";
=======
  version = "0.10.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-62VoAB6RELGzIJQUMcUQM9EEzJjNoiVKXCsJulaf1JQ=";
=======
    hash = "sha256-xXKBKCl+bSaXkQhc+Wwv/fzvWM+DxjSly5LrA7KSmDg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    argcomplete
    colorama
    jmespath
    pygments
    pyyaml
    six
    tabulate
  ];

  nativeCheckInputs = [
    mock
    vcrpy
    pytest
  ];

  checkPhase = ''
    HOME=$TMPDIR pytest .
  '';

  pythonImportsCheck = [
    "knack"
  ];

  meta = with lib; {
    homepage = "https://github.com/microsoft/knack";
    description = "A Command-Line Interface framework";
    changelog = "https://github.com/microsoft/knack/blob/v${version}/HISTORY.rst";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
