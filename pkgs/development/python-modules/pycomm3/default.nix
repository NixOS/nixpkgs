{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "pycomm3";
<<<<<<< HEAD
  version = "1.2.16";
  pyproject = true;

=======
  version = "1.2.14";
  pyproject = true;

  disabled = pythonOlder "3.7";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "ottowayi";
    repo = "pycomm3";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-xcN0TKwWg23CDBmwMRZlPFuKYpeLg7KSXzhRtNuP6Ls=";
=======
    hash = "sha256-KdvmISMH2HHU8N665QevVw7q9Qs5CwjXxcWpLoziY/Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pycomm3" ];

  disabledTestPaths = [
    # Don't test examples as some have additional requirements
    "examples/"
    # No physical PLC available
    "tests/online/"
  ];

<<<<<<< HEAD
  meta = {
    description = "Python Ethernet/IP library for communicating with Allen-Bradley PLCs";
    homepage = "https://github.com/ottowayi/pycomm3";
    changelog = "https://github.com/ottowayi/pycomm3/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python Ethernet/IP library for communicating with Allen-Bradley PLCs";
    homepage = "https://github.com/ottowayi/pycomm3";
    changelog = "https://github.com/ottowayi/pycomm3/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
