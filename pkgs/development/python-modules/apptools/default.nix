{
  lib,
  buildPythonPackage,
  configobj,
  fetchFromGitHub,
  numpy,
  pandas,
  pyface,
  pytestCheckHook,
  setuptools,
  tables,
  traits,
  traitsui,
}:

buildPythonPackage rec {
  pname = "apptools";
  version = "5.3.1";
  pyproject = true;

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

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.concatAttrValues optional-dependencies;

  preCheck = ''
    export HOME=$TMP
  '';

  pythonImportsCheck = [ "apptools" ];

  meta = {
    description = "Set of packages that Enthought has found useful in creating a number of applications";
    homepage = "https://github.com/enthought/apptools";
    changelog = "https://github.com/enthought/apptools/releases/tag/${src.tag}";
    license = lib.licenses.bsdOriginal;
    maintainers = [ ];
  };
}
