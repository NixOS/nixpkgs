{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, future
, numpy
, pillow
, fetchpatch
, scipy
, scikit-learn
, scikitimage
, threadpoolctl
}:

buildPythonPackage rec {
  pname = "batchgenerators";
  version = "0.21";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-q8mBWcy+PkJcfiKtq8P2bnTw56FE1suVS0zUgUEmc5k=";
  };

  propagatedBuildInputs = [
    future
    numpy
    pillow
    scipy
    scikit-learn
    scikitimage
    threadpoolctl
  ];

  checkInputs = [
    pytestCheckHook
  ];

  patches = [
    # Remove deprecated unittest2, https://github.com/MIC-DKFZ/batchgenerators/pull/78
    (fetchpatch {
      name = "remove-unittest2.patch";
      url = "https://github.com/MIC-DKFZ/batchgenerators/commit/87a9437057df8a7550aa3b3eaf840871cc0d5cef.patch";
      sha256 = "sha256-vozBK7g2dLxx9din/R2vU28Mm+LoGAO/BmQlt/ShmEo=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"unittest2",' ""
  '';

  pythonImportsCheck = [
    "batchgenerators"
  ];

  meta = with lib; {
    description = "2D and 3D image data augmentation for deep learning";
    homepage = "https://github.com/MIC-DKFZ/batchgenerators";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
