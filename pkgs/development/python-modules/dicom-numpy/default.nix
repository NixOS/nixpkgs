{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  setuptools,
  numpy,
  pydicom,
}:

buildPythonPackage rec {
  pname = "dicom-numpy";
  version = "0.6.5";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "innolitics";
    repo = "dicom-numpy";
    tag = "v${version}";
    hash = "sha256-pgmREQlstr0GY2ThIWt4hbcSWmaNWgkr2gO4PSgGHqE=";
  };

  postPatch = ''
    substituteInPlace dicom_numpy/zip_archive.py \
      --replace-fail "pydicom.read_file" "pydicom.dcmread"
  '';

  build-system = [
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
    pydicom
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dicom_numpy" ];

  meta = with lib; {
    description = "Read DICOM files into Numpy arrays";
    homepage = "https://github.com/innolitics/dicom-numpy";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
