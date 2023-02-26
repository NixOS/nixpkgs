{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
, setuptools-scm
, click
, logzero
, lxml
, beautifulsoup4
, cachew
, pytz
, ipython
, platformdirs
}:

buildPythonPackage rec {
  pname = "google-takeout-parser";
  version = "2023-02-01";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "seanbreckenridge";
    repo = "google_takeout_parser";
    rev = "c4ce0fd4862605b6ddc1e7f71b845102f7589e20";
    hash = "sha256-PurQ1MCwMGl39Y/mX4BLXC9y/Rjj2JssuMCgGOBlsJQ=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    logzero
    click
    ipython
    lxml
    beautifulsoup4
    cachew
    pytz
    ipython
    platformdirs
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Parses data out of your Google Takeout";
    homepage = "https://github.com/seanbreckenridge/google_takeout_parser";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ qbit ];
  };
}
