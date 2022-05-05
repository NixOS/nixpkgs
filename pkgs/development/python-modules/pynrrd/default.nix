{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pynrrd";
  version = "0.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mhe";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-4UM2NAKWfsjxAoLQCFSPVKG5GukxqppywqvLM0V/dIs=";
  };

  propagatedBuildInputs = [
    numpy
  ];

  pythonImportsCheck = [
    "nrrd"
  ];

  meta = with lib; {
    homepage = "https://github.com/mhe/pynrrd";
    description = "Simple pure-Python reader for NRRD files";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
