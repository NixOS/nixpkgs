{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "assertpy";
  version = "1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "assertpy";
    repo = "assertpy";
    rev = version;
    sha256 = "0hnfh45cmqyp7zasrllwf8gbq3mazqlhhk0sq1iqlh6fig0yfq2f";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "assertpy" ];

  meta = {
    description = "Simple assertion library for unit testing with a fluent API";
    homepage = "https://github.com/assertpy/assertpy";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
