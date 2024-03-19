{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, python-dateutil
, pytz
, regex
}:

buildPythonPackage rec {
  pname = "datefinder";
  version = "0.7.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "akoumjian";
    repo = "datefinder";
    rev = "refs/tags/v${version}";
    hash = "sha256-uOSwS+mHgbvEL+rTfs4Ax9NvJnhYemxFVqqDssy2i7g=";
  };

  propagatedBuildInputs = [
    regex
    pytz
    python-dateutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "datefinder" ];

  meta = {
    description = "Extract datetime objects from strings";
    homepage = "https://github.com/akoumjian/datefinder";
    license = lib.licenses.mit;
    maintainers = lib.teams.deshaw.members;
  };
}
