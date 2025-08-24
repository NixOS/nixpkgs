{
  lib,
  baseline,
  buildPythonPackage,
  fetchFromGitLab,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "plum-py";
  version = "0.8.6";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitLab {
    owner = "dangass";
    repo = "plum";
    rev = "refs/tags/${version}";
    hash = "sha256-gZSRqijKdjqOZe1+4aeycpCPsh6HC5sRbyVjgK+g4wM=";
  };

  postPatch = ''
    # Drop broken version specifier
    sed -i "/python_requires =/d" setup.cfg
  '';

  nativeCheckInputs = [
    baseline
    pytestCheckHook
  ];

  pythonImportsCheck = [ "plum" ];

  enabledTestPaths = [ "tests" ];

  disabledTestPaths = [
    # tests enum.IntFlag behaviour which has been disallowed in python 3.11.6
    # https://gitlab.com/dangass/plum/-/issues/150
    "tests/flag/test_flag_invalid.py"
  ];

  meta = with lib; {
    description = "Classes and utilities for packing/unpacking bytes";
    homepage = "https://plum-py.readthedocs.io/";
    changelog = "https://gitlab.com/dangass/plum/-/blob/${version}/docs/release_notes.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dnr ];
  };
}
