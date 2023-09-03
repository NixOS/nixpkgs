{ lib
, buildPythonPackage
, datalad
, dcm2niix
, dcmstack
, etelemetry
, fetchPypi
, filelock
, git
, nibabel
, nipype
, pydicom
, pytestCheckHook
, pythonOlder
, setuptools
, versioningit
, wheel
}:

buildPythonPackage rec {
  pname = "heudiconv";
  version = "0.13.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UUBRC6RToj4XVbJnxG+EKdue4NVpTAW31RNm9ieF1lU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "versioningit ~=" "versioningit >="
  '';

  nativeBuildInputs = [
    setuptools
    versioningit
    wheel
  ];

  propagatedBuildInputs = [
    nibabel
    pydicom
    nipype
    dcmstack
    etelemetry
    filelock
  ];

  nativeCheckInputs = [
    datalad
    dcm2niix
    pytestCheckHook
    git
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "heudiconv"
  ];

  meta = with lib; {
    homepage = "https://heudiconv.readthedocs.io";
    description = "Flexible DICOM converter for organizing imaging data";
    changelog = "https://github.com/nipy/heudiconv/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
