{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools-scm
, setuptools
, pytestCheckHook
, freezegun
}:

buildPythonPackage rec {
  version = "3.13.1";
  pname = "humanize";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jmoiron";
    repo = pname;
    rev = version;
    sha256 = "sha256-lgGBvYb3ciqETBOR31gxQVD7YyopTtmr++nCwvm63Zs=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    setuptools
  ];

  checkInputs = [
    freezegun
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Python humanize utilities";
    homepage = "https://github.com/jmoiron/humanize";
    license = licenses.mit;
    maintainers = with maintainers; [ rmcgibbo ];
  };

}
