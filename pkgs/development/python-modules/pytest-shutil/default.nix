{
  lib,
  isPyPy,
  buildPythonPackage,
  pytest-fixture-config,
  fetchpatch,

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
  inherit (pytest-fixture-config) version src;
  pyproject = true;

  # imp was removed in Python 3.12
  patches = [
    (fetchpatch {
      name = "stop-using-imp.patch";
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/python-pytest-shutil/stop-using-imp.patch?rev=10";
      hash = "sha256-ZsfOic6VmKIlK+HeAlUwiM4fXgw9wHo445dP9j5/h8Q=";
    })
  ] ++ pytest-fixture-config.patches;

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

  disabledTests =
    [ "test_pretty_formatter" ]
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
