{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
, setuptools-scm
, lxml
}:

buildPythonPackage rec {
  pname = "goodrexport";
  version = "2021-03-26";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "karlicoss";
    repo = pname;
    rev = "10d8cc86a121b9c1e99bb0b27a1bdd18c16ce270";
    hash = "sha256-R2u8ud2r8zCaOlhjK1XQ1KPjnrFHTPZNeUnw2wKLdD0=";
    fetchSubmodules = true;
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    lxml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Goodreads data export";
    homepage = "https://github.com/karlicoss/goodrexport";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ qbit ];
  };
}
