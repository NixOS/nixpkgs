{ lib, buildPythonPackage, fetchPypi, matplotlib, opencv4, numpy }:

buildPythonPackage rec{
  pname = "cmapy";
  version = "0.6.6";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-y1KmswV8SaFG+wlkuDAvL7fWHf5q5t4amLY2qs6AUlU=";
  };

  propagatedBuildInputs = [ matplotlib opencv4 numpy ];
  postPatch = ''
    sed -i 's/opencv-python/opencv/' setup.py
  '';

  meta = with lib;{
    homepage = "https://gitlab.com/cvejarano-oss/cmapy";
    license = licenses.mit;
    description = "Use Matplotlib colormaps with OpenCV in Python";
    mantainers = with mantainers;[ pasqui023 ];
  };
}
