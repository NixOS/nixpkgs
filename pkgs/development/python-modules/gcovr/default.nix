{
  lib,
  buildPythonPackage,
  fetchPypi,
  colorlog,
  jinja2,
  lxml,
  pygments,
  pythonOlder,
  setuptools,
  tomli,
}:

buildPythonPackage rec {
  pname = "gcovr";
  version = "8.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mh3d1FhdE+x3VV211rajHugVh+pvxgT/n80jLLB4LfU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colorlog
    jinja2
    lxml
    pygments
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  # There are no unit tests in the pypi tarball. Most of the unit tests on the
  # github repository currently only work with gcc5, so we just disable them.
  # See also: https://github.com/gcovr/gcovr/issues/206
  doCheck = false;

  pythonImportsCheck = [
    "gcovr"
    "gcovr.configuration"
  ];

  meta = {
    description = "Python script for summarizing gcov data";
    homepage = "https://www.gcovr.com/";
    changelog = "https://github.com/gcovr/gcovr/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "gcovr";
  };
}
