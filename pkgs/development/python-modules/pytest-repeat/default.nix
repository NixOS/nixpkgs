{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-repeat";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-eWc0Ra6ZruMzuBHH0AN660CPkzuImDdf8vT/8eO6aGs=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Pytest plugin for repeating tests";
    homepage = "https://github.com/pytest-dev/pytest-repeat";
    changelog = "https://github.com/pytest-dev/pytest-repeat/blob/v${version}/CHANGES.rst";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ];
  };
}
