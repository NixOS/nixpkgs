{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  setuptools,
  numpy,
  pandas,
  fixVersioneerSourcesHook,
}:

buildPythonPackage rec {
  pname = "ancp-bids";
  version = "0.2.9";
  pyproject = true;

  disabled = pythonOlder "3.7";

  # `tests/data` dir missing from PyPI dist
  src = fetchFromGitHub {
    owner = "ANCPLabOldenburg";
    repo = "ancp-bids";
    tag = version;
    hash = "sha256-Gf11e+TrdGBNFEXqU2HLhnA4DSAq9TGEOkqQ+wBpIhE=";
    nativeBuildInputs = [ fixVersioneerSourcesHook ];
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
    changelog = "https://github.com/ANCPLabOldenburg/ancp-bids/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
