{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "napari-plugin-engine";
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "napari";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-cKpCAEYYRq3UPje7REjzhEe1J9mmrtXs8TBnxWukcNE=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  # Circular dependency: napari
  doCheck = false;

  pythonImportsCheck = [ "napari_plugin_engine" ];

  meta = with lib; {
    description = "First generation napari plugin engine";
    homepage = "https://github.com/napari/napari-plugin-engine";
    license = licenses.mit;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
