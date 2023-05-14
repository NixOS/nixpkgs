{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pytestCheckHook
, pyyaml
, requests
, requests-mock
, sqlite-utils
}:

buildPythonPackage rec {
  pname = "github-to-sqlite";
  version = "2.8.3";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "dogsheep";
    repo = pname;
    rev = version;
    hash = "sha256-4wkwtcChcR7XH421wa3dGdIPhwgeaTFk247zIRX98xo=";
  };

  propagatedBuildInputs = [
    sqlite-utils
    pyyaml
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  disabledTests = [
    "test_scrape_dependents"
  ];

  meta = with lib; {
    description = "Save data from GitHub to a SQLite database";
    homepage = "https://github.com/dogsheep/github-to-sqlite";
    license = licenses.asl20;
    maintainers = with maintainers; [ sarcasticadmin ];
  };
}
