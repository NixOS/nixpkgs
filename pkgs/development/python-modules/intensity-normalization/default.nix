{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pytestCheckHook,
  pytest-cov-stub,
  hatchling,
  nibabel,
  numpy,
  scikit-fuzzy,
  scipy,
}:

buildPythonPackage rec {
  pname = "intensity-normalization";
  version = "3.0.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    pname = "intensity_normalization";
    inherit version;
    hash = "sha256-d5f+Ug/ta9RQjk3JwHmVJQr8g93glzf7IcmLxLeA1tQ=";
  };

  build-system = [ hatchling ];

  dependencies = [
    nibabel
    numpy
    scikit-fuzzy
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];
  enabledTestPaths = [ "tests" ];

  pythonImportsCheck = [
    "intensity_normalization"
    "intensity_normalization.adapters"
    "intensity_normalization.domain"
    "intensity_normalization.normalizers"
    "intensity_normalization.services"
  ];

  meta = {
    homepage = "https://github.com/jcreinhold/intensity-normalization";
    description = "MRI intensity normalization tools";
    changelog = "https://github.com/jcreinhold/intensity-normalization/releases/tag/${version}";
    maintainers = with lib.maintainers; [ bcdarwin ];
    license = lib.licenses.asl20;
    mainProgram = "intensity-normalize";
  };
}
