{
  lib,
  isPyPy,
  buildPythonPackage,
  pytest-fixture-config,

  # build-time
  setuptools,
  setuptools-git,

  # runtime
  pytest,
  mock,
  path,
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
    setuptools-git
  ];

  buildInputs = [ pytest ];

  dependencies = [
    mock
    path
    execnet
    termcolor
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    "test_pretty_formatter"
  ]
  ++ lib.optionals isPyPy [
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
