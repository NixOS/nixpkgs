{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, lxml
, matplotlib
, networkx
, pandas
, requests
, six
}:

buildPythonPackage rec {
  pname = "pyxnat";
  version = "1.6";
  format = "setuptools";
  disabled = pythonOlder "3.8";

  # PyPI dist missing test configuration files:
  src = fetchFromGitHub {
    owner = "pyxnat";
    repo = "pyxnat";
    rev = "refs/tags/${version}";
    hash = "sha256-QejYisvQFN7CsDOx9wAgTHmRZcSEqgIr8twG4XucfZ4=";
  };

  propagatedBuildInputs = [
    lxml
    requests
    six
  ];

  # future is not used, and pathlib is installed part of python38+
  # w/o an external package
  prePatch = ''
    substituteInPlace setup.py \
      --replace "pathlib>=1.0" "" \
      --replace "future>=0.16" ""
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
    # try to access network even though PYXNAT_SKIP_NETWORK_TESTS is set:
    "pyxnat/tests/pipelines_test.py"
    "pyxnat/tests/search_test.py"
    "pyxnat/tests/user_and_project_management_test.py"
  ];
  disabledTests = [
    # try to access network even though PYXNAT_SKIP_NETWORK_TESTS is set:
    "test_ashs_volumes"
    "test_inspector_structure"
  ];

  pythonImportsCheck = [ "pyxnat" ];

  meta = with lib; {
    homepage = "https://pyxnat.github.io/pyxnat";
    description = "Python API to XNAT";
    changelog = "https://github.com/pyxnat/pyxnat/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
