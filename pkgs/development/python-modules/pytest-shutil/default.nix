{
  lib,
  isPyPy,
  buildPythonPackage,
  pytest-fixture-config,

  # build-time
  setuptools,

  # runtime
  pytest,
  execnet,
  termcolor,
  six,

  # tests
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "pytest-shutil";
  inherit (pytest-fixture-config) version src patches;
  pyproject = true;

  postPatch = ''
    cd pytest-shutil
  '';

  build-system = [
    setuptools
  ];

  buildInputs = [ pytest ];

  dependencies = [
    execnet
    termcolor
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals isPyPy [
    "test_run"
    "test_run_integration"
  ];

  meta = with lib; {
    description = "Goodie-bag of unix shell and environment tools for py.test";
    homepage = "https://github.com/manahl/pytest-plugins";
    maintainers = with maintainers; [ ryansydnor ];
    license = licenses.mit;
  };
}
