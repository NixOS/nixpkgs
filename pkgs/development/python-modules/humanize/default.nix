{ lib
, buildPythonPackage
, fetchFromGitHub
, freezegun
, gettext
<<<<<<< HEAD
=======
, importlib-metadata
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, pythonOlder
, hatch-vcs
, hatchling
}:

buildPythonPackage rec {
  pname = "humanize";
<<<<<<< HEAD
  version = "4.8.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "4.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "python-humanize";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-bKTzygQtZ/0UB+zM9735a/xwH4KaoU6C8kUGurbHs2Y=";
=======
    hash = "sha256-sI773uzh+yMiyu1ebsk6zutfyt+tfx/zT/X2AdH5Fyg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatch-vcs
    hatchling
    gettext
  ];

<<<<<<< HEAD
=======
  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postBuild = ''
    scripts/generate-translation-binaries.sh
  '';

  postInstall = ''
    cp -r 'src/humanize/locale' "$out/lib/"*'/site-packages/humanize/'
  '';

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "humanize"
  ];

  meta = with lib; {
    description = "Python humanize utilities";
    homepage = "https://github.com/python-humanize/humanize";
    changelog = "https://github.com/python-humanize/humanize/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ rmcgibbo Luflosi ];
  };
}
