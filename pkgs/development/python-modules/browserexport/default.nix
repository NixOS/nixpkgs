{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
, setuptools-scm
, click
, logzero
, ipython
, mypy
, flake8
, sqlite-backup
}:

buildPythonPackage rec {
  pname = "browserexport";
  version = "0.2.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "seanbreckenridge";
    repo = pname;
    rev = "9b8413f239ce0d152bc6766c1bd12a8afc7aea80";
    hash = "sha256-jzXczP1ZqPYzUXFV11zEyfWuQUildXmuYfDh3C+otSc=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    logzero
    click
    ipython
    sqlite-backup
  ];

  checkInputs = [
    pytestCheckHook
    flake8
    mypy
  ];

  doCheck = true;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Transparent and persistent cache/serialization powered by type hints";
    homepage = "https://github.com/karlicoss/cachew";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ qbit ];
  };
}
