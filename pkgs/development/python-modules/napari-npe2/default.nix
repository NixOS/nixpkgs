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
  version = "0.6.2";

  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "napari";
    repo = "npe2";
    rev = "refs/tags/v${version}";
    hash = "sha256-f4mSsURcf2xvvO/mrsLVpUt+ws73QHk2Ng/NwCR5Q48=";
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
