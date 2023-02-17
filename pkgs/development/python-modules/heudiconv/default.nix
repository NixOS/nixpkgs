{ lib
, buildPythonPackage
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
  version = "0.8.0";
  pname = "heudiconv";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    #sha256 = "0gzqqa4pzhywdbvks2qjniwhr89sgipl5k7h9hcjs7cagmy9gb05";
    sha256 = "1r6y93125mc84c09970ifps5xysp8ffp62rwlzili3q2k1m3fh4v";
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

  meta = with lib; {
    homepage = "https://heudiconv.readthedocs.io";
    description = "Flexible DICOM converter for organizing imaging data";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
