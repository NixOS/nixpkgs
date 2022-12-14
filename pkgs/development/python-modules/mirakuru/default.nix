{
  lib,
  buildPythonPackage,
  psutil,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-cov,
  netcat,
  procps,
  python-daemon,
}:
buildPythonPackage rec {
  pname = "mirakuru";
  version = "2.4.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ClearcodeHQ";
    repo = "mirakuru";
    rev = "v${version}";
    hash = "sha256-0z7Qq0BQV7criQqqK0I9/Rm0u1qa1EQJ+06+oXAl+M0=";
  };

  nativeBuildInputs = [setuptools];

  propagatedBuildInputs = [psutil];

  checkInputs = [pytestCheckHook pytest-cov python-daemon netcat procps];

  pythonImportsCheck = ["mirakuru"];

  meta = with lib; {
    description = "Process executor (not only) for tests";
    homepage = https://github.com/ClearcodeHQ/mirakuru;
    license = licenses.lgpl3Only;
    maintainers = [maintainers.apeschar];
    platforms = platforms.all;
  };
}
