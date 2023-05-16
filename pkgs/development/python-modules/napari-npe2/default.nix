{ lib
, appdirs
, build
, buildPythonPackage
, fetchFromGitHub
, magicgui
, napari # reverse dependency, for tests
, psygnal
, pydantic
, pythonOlder
, pytomlpp
, pyyaml
, rich
, setuptools-scm
, typer
}:

buildPythonPackage rec {
  pname = "napari-npe2";
<<<<<<< HEAD
  version = "0.7.0";
=======
  version = "0.6.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "napari";
    repo = "npe2";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-6kHyz7jMZO3385XaNJ4zFBoQiU1SIRyYZsUeMH5EBXo=";
=======
    hash = "sha256-f4mSsURcf2xvvO/mrsLVpUt+ws73QHk2Ng/NwCR5Q48=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    # npe2 *can* build without it,
    # but then setuptools refuses to acknowledge it when building napari
    setuptools-scm
  ];

  propagatedBuildInputs = [
    appdirs
    build
    magicgui
    pydantic
    pytomlpp
    pyyaml
    rich
    typer
  ];

  pythonImportsCheck = [
    "npe2"
  ];

  passthru.tests = { inherit napari; };

  meta = with lib; {
    description = "Plugin system for napari (the image visualizer)";
    homepage = "https://github.com/napari/npe2";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
