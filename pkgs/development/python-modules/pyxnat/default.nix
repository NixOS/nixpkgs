{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  lxml,
  matplotlib,
  networkx,
  pandas,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyxnat";
  version = "1.6.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  # PyPI dist missing test configuration files:
  src = fetchFromGitHub {
    owner = "pyxnat";
    repo = "pyxnat";
    rev = "refs/tags/${version}";
    hash = "sha256-21nTIYbIYlFWNJTxqsuijamqRunpdc7/VBawvrWadWI=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    lxml
    requests
  ];

  # pathlib is installed part of python38+ w/o an external package
  prePatch = ''
    substituteInPlace setup.py --replace-fail "pathlib>=1.0" ""
    sed -i '/--cov/d' setup.cfg
  '';

  nativeCheckInputs = [
    pytestCheckHook
    matplotlib
    networkx
    pandas
  ];
  preCheck = ''
    export PYXNAT_SKIP_NETWORK_TESTS=1
  '';
  pytestFlagsArray = [ "pyxnat" ];
  disabledTestPaths = [
    # require a running local XNAT instance e.g. in a docker container:
    "pyxnat/tests/attributes_test.py"
    "pyxnat/tests/custom_variables_test.py"
    "pyxnat/tests/interfaces_test.py"
    "pyxnat/tests/pipelines_test.py"
    "pyxnat/tests/provenance_test.py"
    "pyxnat/tests/prearchive_test.py"
    "pyxnat/tests/repr_test.py"
    "pyxnat/tests/resources_test.py"
    "pyxnat/tests/search_test.py"
    "pyxnat/tests/sessionmirror_test.py"
    "pyxnat/tests/test_resource_functions.py"
    "pyxnat/tests/user_and_project_management_test.py"
  ];
  disabledTests = [
    # try to access network even though PYXNAT_SKIP_NETWORK_TESTS is set:
    "test_inspector_structure"
    "test_project_manager"
  ];

  pythonImportsCheck = [ "pyxnat" ];

  meta = with lib; {
    homepage = "https://pyxnat.github.io/pyxnat";
    description = "Python API to XNAT";
    mainProgram = "sessionmirror.py";
    changelog = "https://github.com/pyxnat/pyxnat/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
