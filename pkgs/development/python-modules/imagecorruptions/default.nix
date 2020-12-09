{ buildPythonPackage
, fetchPypi
, numpy
, scikitimage
, stdenv
, opencv3
}:

buildPythonPackage rec {
  pname = "imagecorruptions";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "011e7c84a01f3e41465e5ad1ee48291cd6fd8032f45c836c5ddaad6e09fe0ae2";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'opencv-python >= 3.4.5'," ""
  '';

  propagatedBuildInputs = [
    numpy
    scikitimage
    opencv3
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/bethgelab/imagecorruptions";
    description = "This package provides a set of image corruptions";
    license = licenses.asl20;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
