{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "coqpit";
  version = "0.0.16";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "coqui-ai";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-f1FLjR4VzSOA/VaeseVA4F1NWVJIvokIZIDW1k7fNqU=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "coqpit"
    "coqpit.coqpit"
  ];

  meta = with lib; {
    description = "Simple but maybe too simple config management through python data classes";
    longDescription = ''
      Simple, light-weight and no dependency config handling through python data classes with to/from JSON serialization/deserialization.
    '';
    homepage = "https://github.com/coqui-ai/coqpit";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}
