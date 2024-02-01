{ lib
, fetchFromGitHub
, buildPythonPackage
, normality
, pytestCheckHook
}:
buildPythonPackage rec {
  pname = "fingerprints";
  version = "1.2.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alephdata";
    repo = "fingerprints";
    rev = version;
    hash = "sha256-U2UslCy1OagVTtllCKsEBX4zI/qIczbxs2Cxzy+/Xys=";
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
