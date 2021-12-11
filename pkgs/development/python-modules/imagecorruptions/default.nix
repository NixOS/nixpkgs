{ buildPythonPackage
, fetchFromGitHub
, numpy
, scikitimage
, lib
, opencv3
}:

buildPythonPackage rec {
  pname = "imagecorruptions";
  version = "1.1.2";

  src = fetchFromGitHub {
     owner = "bethgelab";
     repo = "imagecorruptions";
     rev = "v1.1.2";
     sha256 = "17hg5akbkngxa66zn0922icd1vyblns6pw3hg8lmpll3xqal20f4";
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

  doCheck = false;
  pythonImportsCheck = [ "imagecorruptions" ];

  meta = with lib; {
    homepage = "https://github.com/bethgelab/imagecorruptions";
    description = "This package provides a set of image corruptions";
    license = licenses.asl20;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
