{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pyttsx3";
  version = "2.99";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "sha256-/z5P91bCTXK58/LzBODtqv0PWK2w5vS5DZMEQM2osgc=";
    dist = "py3";
    python = "py3";
  };

  # This package has no tests
  doCheck = false;

  meta = with lib; {
    description = "Offline text-to-speech synthesis library";
    homepage = "https://github.com/nateshmbhat/pyttsx3";
    license = licenses.mpl20;
    maintainers = [ maintainers.ethindp ];
  };
}
