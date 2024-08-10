{ lib
, buildPythonPackage
, fetchFromGitHub
, nco
, netcdf4
, numpy
, pytestCheckHook
, python-dateutil
, scipy
, setuptools
}:

buildPythonPackage rec {
  pname = "pynco";
  version = "1.1.2";
  pyproject = true;

  # The source tarball on PyPI does not contain at least tests/conftest.py, so is not testable.
  # Fetching from GitHub gives the full source code.
  src = fetchFromGitHub {
    owner = "nco";
    repo = pname;
    rev = version;
    hash = "sha256-zU0Y11zYQPQ4poyvbSxeOP7NVfEVd6zxDpgtYp4hLKA=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    netcdf4
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook nco ];

  checkInputs = [ python-dateutil ];

  meta = with lib; {
    homepage = "https://github.com/nco/pynco";
    description = "Python bindings for NCO";
    license = licenses.mit;
    maintainers = with maintainers; [ matrss ];
  };
}
