{ lib
, buildPythonPackage
, fetchFromGitHub
, wheel
, setuptools
, setuptools-scm
, pytestCheckHook
, pytest-mypy-plugins
, pytest-cov
, pytest
, mypy
, typing-extensions
}: buildPythonPackage rec
{
  pname = "psygnal";
  version = "0.3.5";
  src = fetchFromGitHub {
    owner = "tlambert03";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-8X6d0KZ61Uy5B68zuxtaimwnDSldWsVrL19iROS4X78=";
  };
  buildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ typing-extensions ];
  checkInputs = [ pytestCheckHook pytest-cov pytest-mypy-plugins ];
  doCheck = false;  # mypy checks are failing
  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  meta = with lib; {
    description = "Pure python implementation of Qt Signals";
    homepage = "https://github.com/tlambert03/psygnal";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
