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

  meta = {
    description = "Cross-platform g2p for Korean";
    homepage = "https://github.com/harmlessman/g2pkk";
    license = lib.licenses.asl20;
    teams = [ lib.teams.tts ];
  };
}
