{ fetchPypi
, buildPythonPackage
, lib
, numpy
, pillow
, pytorch
, torchvision
, ttach
, tqdm
, opencv3
}:

buildPythonPackage rec {
  pname = "grad-cam";
  version = "1.3.7";
  src = fetchPypi {
    inherit pname version;
    sha256 = "y9LlgmgbP7X+Qdx+cs0Z4b1mXgPhgCX1IFCvLTI8ces=";
  };

  propagatedBuildInputs = [
    numpy
    pillow
    pytorch
    torchvision
    ttach
    tqdm
    opencv3
  ];
  ## opencv-python is how grad-cam prefers to get opencv, we use opencv3 instead above
  postPatch = ''
    substituteInPlace requirements.txt --replace "opencv-python" ""
  '';

  pythonImportsCheck = [ "pytorch_grad_cam" ];

  meta = with lib; {
    description = "Class Activation Map methods implemented in Pytorch";
    homepage = "https://github.com/jacobgil/pytorch-grad-cam";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ cfhammill ];
  };
}
