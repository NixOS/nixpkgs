{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  poetry-core,

  # dependencies
  jsonschema,
  numpy,
  pydicom,
  simpleitk,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pydicom-seg";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "razorx89";
    repo = "pydicom-seg";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-2Y3fZHKfZqdp5EU8HfVsmJ5JFfVGZuAR7+Kj7qaTiPM=";
  };

  patches = [
    # https://github.com/razorx89/pydicom-seg/pull/54
    (fetchpatch {
      name = "replace-poetry-with-poetry-core.patch";
      url = "https://github.com/razorx89/pydicom-seg/commit/ac91eaefe3b0aecfe745869972c08de5350d2b61.patch";
      hash = "sha256-xBOVjWZPjyQ8gSj6JLe9B531e11TI3FUFFtL+IelZOM=";
    })
  ];

  pythonRelaxDeps = [
    "jsonschema"
    "numpy"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    jsonschema
    numpy
    pydicom
    simpleitk
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pydicom_seg" ];

  meta = {
    description = "Medical segmentation file reading and writing";
    homepage = "https://github.com/razorx89/pydicom-seg";
    changelog = "https://github.com/razorx89/pydicom-seg/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
    # ModuleNotFoundError: No module named 'pydicom._storage_sopclass_uids'
    broken = true;
  };
}
