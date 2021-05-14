{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, pytestCheckHook
, unittest2
, future
, numpy
, pillow
, scipy
, scikit-learn
, scikitimage
, threadpoolctl
}:

buildPythonPackage rec {
  pname = "batchgenerators";
  version = "0.21";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = pname;
    rev = "v${version}";
    sha256 = "16bk4r0q3m2c9fawpmj4l7kz0x3fyv1spb92grf44gmyricq3jdb";

  };

  propagatedBuildInputs = [
    future numpy pillow scipy scikit-learn scikitimage threadpoolctl
  ];

  checkInputs = [ pytestCheckHook unittest2 ];

  meta = {
    description = "2D and 3D image data augmentation for deep learning";
    homepage = "https://github.com/MIC-DKFZ/batchgenerators";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
