{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "language-tags";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "OnroerendErfgoed";
    repo = "language-tags";
    rev = version;
    sha256 = "sha256-4Ira3EMS64AM8I3SLmUm+m6V5vwtDYf8WDmVDvI+ZOw=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "language_tags" ];

  meta = with lib; {
    description = "Dealing with IANA language tags in Python";
    homepage = "https://language-tags.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
  };
}
