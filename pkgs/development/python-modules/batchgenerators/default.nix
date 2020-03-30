{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, pytest
, unittest2
, future
, numpy
, scipy
, scikitlearn
, scikitimage
, threadpoolctl
}:


buildPythonPackage rec {
  pname = "batchgenerators";
  version = "0.19.7";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qqzwqf5r0q6jh8avz4f9kf8x96crvdnkznhf24pbm0faf8yk67q";
  };

  propagatedBuildInputs = [ future numpy scipy scikitlearn scikitimage threadpoolctl ];
  checkInputs = [ pytest unittest2 ];

  checkPhase = "pytest tests";

  meta = {
    description = "2D and 3D image data augmentation for deep learning";
    homepage = "https://github.com/MIC-DKFZ/batchgenerators";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
