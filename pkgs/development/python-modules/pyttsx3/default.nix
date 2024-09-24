{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pyttsx3";
  version = "2.97";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "sha256-GM4wZDtnutHZc2H7s6PHyo/MdQ7Y6YrCJuu2I7AeSw8=";
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
