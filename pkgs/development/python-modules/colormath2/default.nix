{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  networkx,
  numpy,
  pytest7CheckHook,
}:

buildPythonPackage rec {
  pname = "colormath2";
  version = "3.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bkmgit";
    repo = "python-colormath2";
    tag = version;
    hash = "sha256-G8b0L8A2RzbVQFPNg2fuBklqTNjo3yqvek/+GnqtsHc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    networkx
    numpy
  ];

  nativeCheckInputs = [ pytest7CheckHook ];

  pythonImportsCheck = [ "colormath2" ];

  meta = {
    description = "Color math and conversion library (fork)";
    homepage = "https://github.com/bkmgit/python-colormath2";
    changelog = "https://github.com/bkmgit/python-colormath2/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ apraga ];
  };
}
