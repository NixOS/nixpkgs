{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  numpy,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  version = "3.4.0";
  pname = "opt-einsum";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "opt_einsum";
    inherit version;
    hash = "sha256-lspy8biG0UgkE0h4NJgZTFd/owqPqsEIWGsU8bpEc6w=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "opt_einsum" ];

<<<<<<< HEAD
  meta = {
    description = "Optimizing NumPy's einsum function with order optimization and GPU support";
    homepage = "https://github.com/dgasmith/opt_einsum";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teh ];
=======
  meta = with lib; {
    description = "Optimizing NumPy's einsum function with order optimization and GPU support";
    homepage = "https://github.com/dgasmith/opt_einsum";
    license = licenses.mit;
    maintainers = with maintainers; [ teh ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
