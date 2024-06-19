{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,

  colormath,
  cython,
  oldest-supported-numpy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "color-operations";
  version = "0.1.3";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "vincentsarago";
    repo = "color-operations";
    rev = version;
    hash = "sha256-KsrgilcNK2ufPKrhtGdf8mdlFzhsHB2jHN+WDlZqabc=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  propagatedBuildInputs = [ oldest-supported-numpy ];

  nativeCheckInputs = [
    colormath
    pytestCheckHook
  ];

  preCheck = ''
    python setup.py build_ext --inplace
  '';

  pythonImportsCheck = [ "color_operations" ];

  meta = {
    description = "Apply basic color-oriented image operations. Fork of rio-color";
    homepage = "https://github.com/vincentsarago/color-operations";
    license = lib.licenses.mit;
    maintainers = lib.teams.geospatial.members;
  };
}
