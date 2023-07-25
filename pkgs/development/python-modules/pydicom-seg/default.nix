{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, pythonRelaxDepsHook
, poetry-core
, jsonschema
, numpy
, pydicom
, simpleitk
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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  pythonRelaxDeps = [
    "jsonschema"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    jsonschema
    numpy
    pydicom
    simpleitk
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pydicom_seg"
  ];

  meta = with lib; {
    description = "Medical segmentation file reading and writing";
    homepage = "https://github.com/razorx89/pydicom-seg";
    changelog = "https://github.com/razorx89/pydicom-seg/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
