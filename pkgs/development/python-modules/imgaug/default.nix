{ stdenv, buildPythonPackage, fetchPypi, numpy, scipy, scikitimage, opencv3, six }:

buildPythonPackage rec {
  pname = "imgaug";
  version = "0.2.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03dcbb3d7485de372eacde4b890b676e0c7a992524ee4bc72bd05a9a1cc5f9a4";
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
