{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dendropy";
  version = "4.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jeetsukumaran";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FP0+fJkkFtSysPxoHXjyMgF8pPin7aRyzmHe9bH8LlM=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # FileNotFoundError: [Errno 2] No such file or directory: 'paup'
    "test_basic_split_count_with_incorrect_rootings_raises_error"
    "test_basic_split_count_with_incorrect_weight_treatment_raises_error"
    "test_basic_split_counting_under_different_rootings"
    "test_group1"
    # AssertionError: 6 != 5
    "test_by_num_lineages"
    # AttributeError: module 'collections' has no attribute 'Iterable'
    "test_findall_multiple"
  ];

  pythonImportsCheck = [
    "dendropy"
  ];

  meta = with lib; {
    description = "Python library for phylogenetic computing";
    homepage = "https://dendropy.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ unode ];
  };
}
