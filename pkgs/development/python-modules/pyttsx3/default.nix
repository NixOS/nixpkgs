{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pyttsx3";
  version = "2.98";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "sha256-s/tMpNWuT45oNtaze/X+4P1R0Vf/on+5Bkvm5749o3o=";
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
