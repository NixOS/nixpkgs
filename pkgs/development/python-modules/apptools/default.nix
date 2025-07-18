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
  traits,
  traitsui,
}:

buildPythonPackage rec {
  pname = "apptools";
  version = "5.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "enthought";
    repo = "apptools";
    tag = version;
    hash = "sha256-46QiVLWdlM89GMCIqVNuNGJjT2nwWJ1c6DyyvEPcceQ=";
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

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (lib.attrValues optional-dependencies);

  preCheck = ''
    export HOME=$TMP
  '';

  pythonImportsCheck = [ "apptools" ];

  meta = with lib; {
    description = "Set of packages that Enthought has found useful in creating a number of applications";
    homepage = "https://github.com/enthought/apptools";
    changelog = "https://github.com/enthought/apptools/releases/tag/${src.tag}";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ ];
  };
}
