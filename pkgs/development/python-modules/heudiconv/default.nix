{ lib
, buildPythonPackage
<<<<<<< HEAD
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
=======
, fetchPypi
, isPy27
, pytest
, mock
, dcm2niix
, nibabel
, pydicom
, nipype
, dcmstack
, etelemetry
, filelock
}:

buildPythonPackage rec {
  version = "0.12.2";
  pname = "heudiconv";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    #sha256 = "0gzqqa4pzhywdbvks2qjniwhr89sgipl5k7h9hcjs7cagmy9gb05";
    sha256 = "sha256-cYr74mw7tXRJRr8rXlu1UMZuU3YXXfDzhuc+vaa+7PQ=";
  };

  postPatch = ''
    # doesn't exist as a separate package with Python 3:
    substituteInPlace heudiconv/info.py --replace "'pathlib'," ""
  '';

  propagatedBuildInputs = [
    dcm2niix nibabel pydicom nipype dcmstack etelemetry filelock
  ];

  nativeCheckInputs = [ dcm2niix pytest mock ];

  # test_monitor and test_dlad require 'inotify' and 'datalad' respectively,
  # and these aren't in Nixpkgs
  checkPhase = "pytest -k 'not test_dlad and not test_monitor' heudiconv/tests";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://heudiconv.readthedocs.io";
    description = "Flexible DICOM converter for organizing imaging data";
<<<<<<< HEAD
    changelog = "https://github.com/nipy/heudiconv/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
