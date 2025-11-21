{
  lib,
  buildPythonPackage,
  docutils,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-toolbox";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cool-RR";
    repo = "python_toolbox";
    tag = version;
    hash = "sha256-pbo4vhypM97OXh6CxK42EbZdrXljvj5rmP9C9RDPo5g=";
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
    changelog = "https://github.com/cool-RR/python_toolbox/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
  };
}
