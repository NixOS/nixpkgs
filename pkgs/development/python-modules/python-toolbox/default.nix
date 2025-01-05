{
  lib,
  buildPythonPackage,
  docutils,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-toolbox";
  version = "1.0.11";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "cool-RR";
    repo = "python_toolbox";
    tag = version;
    hash = "sha256-Y9RmVndgsBESrUCEORUwAdaFYBiunY3kWArhB9d7bw4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    docutils
    pytestCheckHook
  ];

  disabledTestPaths = [
    # file imports 'dummy_threading', which was deprecated since py37
    # and removed in py39
    "test_python_toolbox/test_cute_profile/test_cute_profile.py"
  ];

  disabledTests = [
    # AssertionError
    "test_repr"
  ];

  meta = with lib; {
    description = "Tools for testing PySnooper";
    homepage = "https://github.com/cool-RR/python_toolbox";
    changelog = "https://github.com/cool-RR/python_toolbox/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
  };
}
