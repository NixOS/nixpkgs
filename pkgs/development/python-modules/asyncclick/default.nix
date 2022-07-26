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
  version = "8.0.1.3";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python-trio";
    repo = pname;
    rev = version;
    sha256 = "03b8zz8i3aqzxr3ffzb4sxnrcm3gsk9r4hmr0fkml1ahi754bx2r";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    anyio
  ];

  checkInputs = [
    pytestCheckHook
    trio
  ];

  disabledTests = [
    # RuntimeWarning: coroutine 'Context.invoke' was never awaited
    "test_context_invoke_type"
  ];

  pythonImportsCheck = [ "asyncclick" ];

  meta = with lib; {
    description = "Python composable command line utility";
    homepage = "https://github.com/python-trio/asyncclick";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
