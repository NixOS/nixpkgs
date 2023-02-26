{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
, setuptools-scm
, pytz
}:

buildPythonPackage rec {
  pname = "pinbexport";
  version = "2022-05-14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "karlicoss";
    repo = pname;
    rev = "f161f9fbb51bf8f907252d971435b5085e25ff13";
    hash = "sha256-TiGjNHpKtykKxfH6/m/B2kxeDLvO+sAphkOiYzoej8c=";
    fetchSubmodules = true;
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pytz
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Export your bookmarks from Pinboard";
    homepage = "https://github.com/karlicoss/pinbexport";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ qbit ];
  };
}
