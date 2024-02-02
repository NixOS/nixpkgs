{ lib
, anyio
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, pytestCheckHook
, pythonOlder
, trio
}:

buildPythonPackage rec {
  pname = "asyncclick";
  version = "8.1.7.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "python-trio";
    repo = "asyncclick";
    rev = "refs/tags/${version}";
    hash = "sha256-gx7s/HikvjsXalc0Z73JWMKc1SlhR+kohwk2sW4o19I=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    anyio
  ];

  nativeCheckInputs = [
    pytestCheckHook
    trio
  ];

  pytestFlagsArray = [
    "-W" "ignore::trio.TrioDeprecationWarning"
  ];

  disabledTests = [
    # AttributeError: 'Context' object has no attribute '_ctx_mgr'
    "test_context_pushing"
  ];

  pythonImportsCheck = [
    "asyncclick"
  ];

  meta = with lib; {
    description = "Python composable command line utility";
    homepage = "https://github.com/python-trio/asyncclick";
    changelog = "https://github.com/python-trio/asyncclick/blob/${version}/CHANGES.rst";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
