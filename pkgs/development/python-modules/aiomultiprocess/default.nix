{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiomultiprocess";
  version = "0.9.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "omnilib";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yOP69FXDb2Grmtszx7oa6uiJGUar8su3KwqQPI+xjrw=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "aiomultiprocess/tests/*.py" ];

  disabledTests = [
    # tests are flaky and make the whole test suite time out
    "test_pool_worker_exceptions"
    "test_pool_worker_max_tasks"
    "test_pool_worker_stop"
  ];

  pythonImportsCheck = [ "aiomultiprocess" ];

  meta = with lib; {
    description = "Python module to improve performance";
    longDescription = ''
      aiomultiprocess presents a simple interface, while running a full
      AsyncIO event loop on each child process, enabling levels of
      concurrency never before seen in a Python application. Each child
      process can execute multiple coroutines at once, limited only by
      the workload and number of cores available.
    '';
    homepage = "https://github.com/omnilib/aiomultiprocess";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.fab ];
  };
}
