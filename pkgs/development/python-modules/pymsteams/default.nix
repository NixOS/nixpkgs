{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "pymsteams";
  version = "0.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rveachkc";
    repo = pname;
    rev = version;
    hash = "sha256-H1AEjUnEK+seKsnFnHpn1/aHxXcbyz67NbzhlGDtbk4=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [
    "pymsteams"
  ];

  meta = with lib; {
    description = "Python module to interact with Microsoft Teams";
    homepage = "https://github.com/rveachkc/pymsteams";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
