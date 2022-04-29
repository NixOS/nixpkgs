{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
}:

buildPythonPackage rec {
  pname = "pynrrd";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "mhe";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-4UM2NAKWfsjxAoLQCFSPVKG5GukxqppywqvLM0V/dIs=";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with lib; {
    homepage = "https://github.com/mhe/pynrrd";
    description = "Simple pure-Python reader for NRRD files";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
