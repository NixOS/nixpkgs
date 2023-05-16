{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, lxml
, matplotlib
, networkx
, pandas
=======
, fetchPypi
, pythonOlder
, nose
, lxml
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, requests
, six
}:

buildPythonPackage rec {
  pname = "pyxnat";
<<<<<<< HEAD
  version = "1.6";
  disabled = pythonOlder "3.8";

  # PyPI dist missing test configuration files:
  src = fetchFromGitHub {
    owner = "pyxnat";
    repo = "pyxnat";
    rev = "refs/tags/${version}";
    hash = "sha256-QejYisvQFN7CsDOx9wAgTHmRZcSEqgIr8twG4XucfZ4=";
=======
  version = "1.5";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Y8mj6OfZXyE1q3C8HyVzGySuZB6rLSsL/CV/7axxaec=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
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
=======
  '';

  nativeCheckInputs = [ nose ];
  checkPhase = "nosetests pyxnat/tests";
  doCheck = false;  # requires a docker container running an XNAT server
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [ "pyxnat" ];

  meta = with lib; {
    homepage = "https://pyxnat.github.io/pyxnat";
    description = "Python API to XNAT";
<<<<<<< HEAD
    changelog = "https://github.com/pyxnat/pyxnat/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
