{ stdenv, buildPythonPackage, fetchPypi, numpy, scipy, scikitimage, opencv3, six }:

buildPythonPackage rec {
  pname = "imgaug";
  version = "0.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wy8ydkqq0jrwxwdv04q89n3gwsr9pjaspsbw26ipg5a5lnhb9c2";
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
  };
}
