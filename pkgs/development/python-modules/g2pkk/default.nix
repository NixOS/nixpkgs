{
  lib,
  buildPythonPackage,
  fetchPypi,
  jamo,
  nltk,
}:

buildPythonPackage rec {
  pname = "g2pkk";
  version = "0.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YarV1Btn1x3Sm4Vw/JDSyJy3ZJMXAQHZJJJklSG0R+Q=";
  };

  propagatedBuildInputs = [
    jamo
    nltk
  ];

  pythonImportsCheck = [ "g2pkk" ];

  doCheck = false;

  meta = with lib; {
    description = "Cross-platform g2p for Korean";
    homepage = "https://github.com/harmlessman/g2pkk";
    license = licenses.asl20;
    maintainers = teams.tts.members;
  };
}
