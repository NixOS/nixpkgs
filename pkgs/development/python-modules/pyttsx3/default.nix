{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pyttsx3";
  version = "2.91";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "sha256-jxkhfE1lpGhw4LgvLn6xVw7CssqAUX++7gleVPdvc+I=";
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
