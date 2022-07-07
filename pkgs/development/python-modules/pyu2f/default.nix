{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, mock
, pyfakefs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyu2f";
  version = "0.1.5a";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = version;
    sha256 = "0mx7bn1p3n0fxyxa82wg3c719hby7vqkxv57fhf7zvhlg2zfnr0v";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ mock pyfakefs pytestCheckHook ];

  meta = with lib; {
    description = "U2F host library for interacting with a U2F device over USB";
    homepage = "https://github.com/google/pyu2f";
    license = licenses.asl20;
    maintainers = with maintainers; [ prusnak ];
  };
}
