{ basicsr
, buildPythonPackage
, cython
, facexlib
, fetchPypi
, gfpgan
, numpy
, opencv-python
, pillow
, torch
, torchvision
, tqdm
}:

buildPythonPackage rec {
  pname = "realesrgan";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zpcri2pf33jmy64zvl2rj08zc6zrh1gb4bfc1qp0i4zmfbdldhd";
  };

  patches = [ ./root_dir.patch ];

  buildInputs = [ cython numpy ];
  propagatedBuildInputs = [
    basicsr
    facexlib
    gfpgan
    numpy
    opencv-python
    pillow
    torch
    torchvision
    tqdm
  ];

  # TODO FIXME
  doCheck = false;

  meta = {
    description =
      "Real-ESRGAN aims at developing Practical Algorithms for General Image Restoration";
    homepage = "https://github.com/xinntao/Real-ESRGAN";
  };
}
