{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pythonOlder,
  pytestCheckHook,
  setuptools,
  numpy,
  pandas,
}:

buildPythonPackage rec {
  pname = "ancp-bids";
  version = "0.2.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  # `tests/data` dir missing from PyPI dist
  src = fetchFromGitHub {
    owner = "ANCPLabOldenburg";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-c6X1gCYAezgZQP6xfQPfKW8V35F1cnTdbryEp3sZ4jw=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    numpy
    pandas
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ancpbids" ];

  pytestFlagsArray = [ "tests/auto" ];

  disabledTests = [ "test_fetch_dataset" ];

  meta = with lib; {
    homepage = "https://ancpbids.readthedocs.io";
    description = "Read/write/validate/query BIDS datasets";
    changelog = "https://github.com/ANCPLabOldenburg/ancp-bids/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
