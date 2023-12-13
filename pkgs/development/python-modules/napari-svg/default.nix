{ lib
, buildPythonPackage
, fetchFromGitHub
, imageio
, napari-plugin-engine
, pythonOlder
, setuptools-scm
, vispy
}:

buildPythonPackage rec {
  pname = "napari-svg";
  version = "0.1.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "napari";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-lvI6RWT9oUE95vL6WO75CASc/Z+1G5UMm2p8vhqIjA0=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    vispy
    napari-plugin-engine
    imageio
  ];

  # Circular dependency: napari
  doCheck = false;

  meta = with lib; {
    description = "A plugin for writing svg files from napari";
    homepage = "https://github.com/napari/napari-svg";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
