{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "gtts-token";
  version = "1.1.3";

  src = fetchPypi {
    pname = "gTTS-token";
    inherit version;
    sha256 = "9d6819a85b813f235397ef931ad4b680f03d843c9b2a9e74dd95175a4bc012c5";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Tests only in github repo, require working internet connection
  doCheck = false;

  meta = with lib; {
    description = "Calculates a token to run the Google Translate text to speech";
    homepage = "https://github.com/boudewijn26/gTTS-token";
    license = licenses.mit;
    maintainers = [ maintainers.makefu ];
  };
}

