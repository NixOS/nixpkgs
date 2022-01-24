{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, nose
, nibabel
, pydicom
}:

buildPythonPackage rec {
  pname = "dcmstack";
  version = "0.8";

  disabled = pythonAtLeast "3.8";
  # https://github.com/moloney/dcmstack/issues/67

  src = fetchFromGitHub {
    owner = "moloney";
    repo = pname;
    rev = "v${version}";
    sha256 = "1n24pp3rqz7ss1z6276fxynnppraxadbl3b9p8ijrcqnpzbzih7p";
  };

  propagatedBuildInputs = [ nibabel pydicom ];

  checkInputs = [ nose ];
  checkPhase = ''
    runHook preCheck
    nosetests
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/moloney/dcmstack";
    description = "DICOM to Nifti conversion preserving metadata";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
