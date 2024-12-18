{
  lib,
  buildPythonPackage,
  configobj,
  fetchFromGitHub,
  numpy,
  pandas,
  pyface,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  tables,
  tmpdirAsHomeHook,
  traits,
  traitsui,
}:

buildPythonPackage rec {
  pname = "apptools";
  version = "5.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "enthought";
    repo = "apptools";
    tag = version;
    hash = "sha256-qNtDHmvl5HbtdbjnugVM7CKVCW+ysAwRB9e2Ounh808=";
  };

  build-system = [ setuptools ];

  dependencies = [ traits ];

  optional-dependencies = {
    gui = [
      pyface
      traitsui
    ];
    h5 = [
      numpy
      pandas
      tables
    ];
    persistence = [ numpy ];
    preferences = [ configobj ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    tmpdirAsHomeHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "apptools" ];

  meta = with lib; {
    description = "Set of packages that Enthought has found useful in creating a number of applications";
    homepage = "https://github.com/enthought/apptools";
    changelog = "https://github.com/enthought/apptools/releases/tag/${version}";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ ];
  };
}
