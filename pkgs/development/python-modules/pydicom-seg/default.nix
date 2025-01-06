{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pythonOlder,
  pytestCheckHook,
  poetry-core,
  jsonschema,
  numpy,
  pydicom,
  simpleitk,
}:

buildPythonPackage rec {
  pname = "pydicom-seg";
  version = "0.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "razorx89";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-2Y3fZHKfZqdp5EU8HfVsmJ5JFfVGZuAR7+Kj7qaTiPM=";
    fetchSubmodules = true;
  };

  patches = [
    # https://github.com/razorx89/pydicom-seg/pull/54
    (fetchpatch {
      name = "replace-poetry-with-poetry-core.patch";
      url = "https://github.com/razorx89/pydicom-seg/commit/ac91eaefe3b0aecfe745869972c08de5350d2b61.patch";
      hash = "sha256-xBOVjWZPjyQ8gSj6JLe9B531e11TI3FUFFtL+IelZOM=";
    })
  ];

  pythonRelaxDeps = [ "jsonschema" ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    jsonschema
    numpy
    pydicom
    simpleitk
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pydicom_seg" ];

  meta = with lib; {
    description = "Medical segmentation file reading and writing";
    homepage = "https://github.com/razorx89/pydicom-seg";
    changelog = "https://github.com/razorx89/pydicom-seg/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
