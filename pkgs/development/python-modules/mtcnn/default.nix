{ lib
, buildPythonPackage
, fetchPypi
, opencv3
, tensorflow
, Keras
}:


buildPythonPackage rec {
  pname = "mtcnn";
  version = "0.1.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256:0arhh6ir8vrmscgg0i9yi6qz6g7fz10r022a7nw2rrjbb1s755fh";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "opencv-python>=4.1.0" ""
  '';

  propagatedBuildInputs = [
    opencv3
    Keras
    tensorflow
  ];

  meta = with lib; {
    description = "Implementation of the MTCNN face detector for Keras in Python3.4+";
    homepage = "https://github.com/ipazc/mtcnn";
    license = licenses.mit;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
