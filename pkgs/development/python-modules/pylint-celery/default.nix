{
  buildPythonPackage,
  fetchFromGitHub,
  isPy3k,
  lib,

  # pythonPackages
  pylint-plugin-utils,
}:

buildPythonPackage rec {
  pname = "pylint-celery";
  version = "0.3";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pylint-celery";
    rev = version;
    hash = "sha256-V3mjFovlUjvOZB+ZHlbWNRf/5Qr+EnuJOIKJgFXm0BU=";
  };

  propagatedBuildInputs = [ pylint-plugin-utils ];

  # Testing requires a very old version of pylint, incompatible with other dependencies
  doCheck = false;

  meta = {
    description = "Pylint plugin to analyze Celery applications";
    homepage = "https://github.com/PyCQA/pylint-celery";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
