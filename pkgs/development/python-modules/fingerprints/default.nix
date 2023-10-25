{ lib
, fetchFromGitHub
, buildPythonPackage
, normality
, pytestCheckHook
}:
buildPythonPackage rec {
  pname = "fingerprints";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "alephdata";
    repo = "fingerprints";
    rev = version;
    hash = "sha256-rptBM08dvivfglPvl3PZd9V/7u2SHbJ/BxfVHNGMt3A=";
  };

  propagatedBuildInputs = [
    normality
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "fingerprints"
  ];

  meta = with lib; {
    description = "A library to generate entity fingerprints";
    homepage = "https://github.com/alephdata/fingerprints";
    license = licenses.mit;
    maintainers = [ ];
  };
}
