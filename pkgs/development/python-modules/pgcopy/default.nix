{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  psycopg2,
  pytz,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pgcopy";
  version = "1.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "altaurog";
    repo = "pgcopy";
    tag = version;
    hash = "sha256-MvPWv5Xrb7tK9hyXaxoc7a5T/H91RUVIDeeWzCyhV6A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    psycopg2
    pytz
  ];

  # Tests require a running PostgreSQL instance
  doCheck = false;

  pythonImportsCheck = [ "pgcopy" ];

  meta = {
    description = "Fast data loading into PostgreSQL with binary COPY";
    homepage = "https://github.com/altaurog/pgcopy";
    changelog = "https://github.com/altaurog/pgcopy/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fangpen ];
  };
}
