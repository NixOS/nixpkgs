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
  version = "2.8.2";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "dogsheep";
    repo = pname;
    rev = version;
    sha256 = "16mw429ppnhgsa98qs3fhprqvdpqbr5q1biq3ql8rsf38difdbl8";
  };

  propagatedBuildInputs = [
    sqlite-utils
    pyyaml
    requests
  ];

  checkInputs = [
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
