{ stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, lib
, cmake
, setuptools
, typing-extensions
, pybind11
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "optree";
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "metaopt";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VnnnEoXkYJO+S7baH+JZvsW18Tk3TiY9+Cd230OlZWo=";
  };

  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [
    typing-extensions
  ];
  nativeBuildInputs = [
    setuptools
    pybind11
    cmake
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];
  # prevent import failures from pytest
  preCheck = ''
    rm -r optree
  '';
  disabledTests = [
    # Fails because the 'test_treespec' module can't be found
    "test_treespec_pickle_missing_registration"
  ];
  pythonImportsCheck = [
    "optree"
  ];

  meta = with lib; {
    homepage = "https://github.com/metaopt/optree";
    changelog = "https://github.com/metaopt/optree/releases/tag/v${version}";
    description = "Optimized PyTree Utilities";
    maintainers = with maintainers; [ pandapip1 ];
    license = licenses.asl20;
  };
}
