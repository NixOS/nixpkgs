{ lib
, buildPythonPackage
, fetchFromGitHub
, imageio
, ipykernel
, ipython
, napari-plugin-engine
, pythonOlder
, qtconsole
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "napari-console";
  version = "0.0.7";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "napari";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-vHLCVMgrcs54pGb48wQpc0h7QBIfE6r7hCSoDNI3QvA=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    imageio
    ipykernel
    ipython
    napari-plugin-engine
    qtconsole
  ];

  # Circular dependency: napari
  doCheck = false;

  pythonImportsCheck = [
    "napari_console"
  ];

  meta = with lib; {
    description = "A plugin that adds a console to napari";
    homepage = "https://github.com/napari/napari-console";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
