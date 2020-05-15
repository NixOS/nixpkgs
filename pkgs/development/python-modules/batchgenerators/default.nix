{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, pytest
, unittest2
, future
, numpy
, pillow
, scipy
, scikitlearn
, scikitimage
, threadpoolctl
}:

buildPythonPackage rec {
  pname = "batchgenerators";
  version = "0.20.0";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cc3i4wznqb7lk8n6jkprvkpsby6r7khkxqwn75k8f01mxgjfpvf";
    
  };

  propagatedBuildInputs = [
    future numpy pillow scipy scikitlearn scikitimage threadpoolctl
  ];

  checkInputs = [ pytest unittest2 ];

  checkPhase = "pytest tests";

  meta = {
    description = "2D and 3D image data augmentation for deep learning";
    homepage = "https://github.com/MIC-DKFZ/batchgenerators";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
