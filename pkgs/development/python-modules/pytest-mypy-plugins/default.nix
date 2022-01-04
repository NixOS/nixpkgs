{ lib
, buildPythonPackage
, fetchFromGitHub
, chevron
, pyyaml
, mypy
, pytest
, decorator
, regex
}:

buildPythonPackage rec {
  pname = "pytest-mypy-plugins";
  version = "1.9.2";
  src = fetchFromGitHub {
    owner = "typeddjango";
    repo = pname;
    rev = version;
    sha256 = "sha256-Me5P4Q2M+gGEWlUVgQ0L048rVUOlUzVMgZZcqZPeE4Q=";
  };
  propagatedBuildInputs = [ chevron pyyaml mypy pytest decorator regex ];

  meta = with lib; {
    description = "pytest plugin for testing mypy types, stubs, and plugins";
    homepage = "https://github.com/TypedDjango/pytest-mypy-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
