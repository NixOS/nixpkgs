{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "coqpit";
  version = "0.0.15";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "coqui-ai";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-i2Lf7YQ9Ht4AlmfIBvJTWNPgEk8Kv92rs5VxuPgvR5U=";
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
