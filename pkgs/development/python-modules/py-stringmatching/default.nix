{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # dependencies
  numpy,
  six,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "py-stringmatching";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "anhaidgroup";
    repo = "py_stringmatching";
    tag = "v${version}";
    hash = "sha256-gQiIIN0PeeM81ZHsognPFierf9ZXasq/JqxsYZmLAnU=";
  };

  pyproject = true;

  build-system = [
    setuptools
    cython
  ];

  dependencies = [
    numpy
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    cd $out
  '';

  pythonImportsCheck = [ "py_stringmatching" ];

  meta = with lib; {
    broken = lib.versionAtLeast numpy.version "2";
    description = "Python string matching library including string tokenizers and string similarity measures";
    homepage = "https://github.com/anhaidgroup/py_stringmatching";
    changelog = "https://github.com/anhaidgroup/py_stringmatching/blob/v${version}/CHANGES.txt";
    license = licenses.bsd3;
  };
}
