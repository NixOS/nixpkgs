{ stdenv, buildPythonPackage, fetchPypi, numpy, scipy, scikitimage, opencv3, six }:

buildPythonPackage rec {
  pname = "imgaug";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e1354d41921f1b306b50c5141b4870f17e81b531cae2f5c3093da9dc4dcb3cf4";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    scikitimage
    opencv3
    six
  ];

  # disable tests when there are no tests in the PyPI archive
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/aleju/imgaug;
    description = "Image augmentation for machine learning experiments";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai ];
    broken = true; # opencv-python bindings aren't available yet, and look non-trivial
  };
}
