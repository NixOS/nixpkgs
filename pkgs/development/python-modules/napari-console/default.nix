{ lib
, buildPythonPackage
, fetchFromGitHub
, imageio
, ipykernel
, ipython
, napari-plugin-engine
, pytest
, pytestCheckHook
, qtconsole
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "napari-console";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "napari";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-aVdYOzkZ+dqB680oDjNCg6quXU+QgUZI09E/MSTagyA=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  # setup.py somehow requires pytest
  propagatedBuildInputs = [
    imageio
    ipykernel
    ipython
    napari-plugin-engine
    pytest
    qtconsole
  ];

  chechInputs = [
    pytestCheckHook
  ];

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
