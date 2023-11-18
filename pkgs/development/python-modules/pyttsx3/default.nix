{ stdenv, lib, buildPythonPackage, fetchPypi, espeak-ng }:

buildPythonPackage rec {
  pname = "pyttsx3";
  version = "2.90";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "a585b6d8cffc19bd92db1e0ccbd8aa9c6528dd2baa5a47045d6fed542a44aa19";
    dist = "py3";
    python = "py3";
  };

  # This package has no tests
  doCheck = false;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Offline text-to-speech synthesis library";
    homepage = "https://github.com/nateshmbhat/pyttsx3";
    license = licenses.mpl20;
    maintainers = [ maintainers.ethindp ];
  };
}
