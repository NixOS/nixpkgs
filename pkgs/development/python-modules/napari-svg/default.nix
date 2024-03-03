{ lib
, buildPythonPackage
, fetchFromGitHub
, imageio
, napari-plugin-engine
, numpy
, pythonOlder
, setuptools-scm
, vispy
}:

buildPythonPackage rec {
  pname = "napari-svg";
  version = "0.1.10";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "napari";
    repo = "napari-svg";
    rev = "refs/tags/v${version}";
    hash = "sha256-ywN9lUwBFW8zP7ivP7MNTYFbTCcmaZxAuKr056uY68Q=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    imageio
    napari-plugin-engine
    numpy
    vispy
  ];

  # Circular dependency: napari
  doCheck = false;

  meta = with lib; {
    description = "A plugin for writing svg files from napari";
    homepage = "https://github.com/napari/napari-svg";
    changelog = "https://github.com/napari/napari-svg/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
