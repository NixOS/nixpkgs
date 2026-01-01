{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-check";
<<<<<<< HEAD
  version = "2.6.2";
=======
  version = "2.6.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_check";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-XiEoQFsUl4rXTyHzIl/MUruxzHxBpV1eqtnx480n5C4=";
=======
    hash = "sha256-m+TFmgmCcSkQkUjIXXtZZLV/ClztG2GUWcow5vRjykI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ hatchling ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_check" ];

<<<<<<< HEAD
  meta = {
    description = "Pytest plugin allowing multiple failures per test";
    homepage = "https://github.com/okken/pytest-check";
    changelog = "https://github.com/okken/pytest-check/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flokli ];
=======
  meta = with lib; {
    description = "Pytest plugin allowing multiple failures per test";
    homepage = "https://github.com/okken/pytest-check";
    changelog = "https://github.com/okken/pytest-check/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
