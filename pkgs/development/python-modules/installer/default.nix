{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchFromGitHub,
  pytestCheckHook,
  flit-core,
  installer,
  mock,
}:

buildPythonPackage rec {
  pname = "installer";
  version = "0.7.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "installer";
    rev = version;
    hash = "sha256-thHghU+1Alpay5r9Dc3v7ATRFfYKV8l9qR0nbGOOX/A=";
  };

  patches = lib.optionals (pythonAtLeast "3.13") [
    # Fix compatibility with Python 3.13
    # https://github.com/pypa/installer/pull/201
    ./python313-compat.patch
  ];

  nativeBuildInputs = [ flit-core ];

  # We need to disable tests because this package is part of the bootstrap chain
  # and its test dependencies cannot be built yet when this is being built.
  doCheck = false;

  passthru.tests = {
    pytest = buildPythonPackage {
      pname = "${pname}-pytest";
      inherit version;
      format = "other";

      dontBuild = true;
      dontInstall = true;

      nativeCheckInputs = [
        installer
        mock
        pytestCheckHook
      ];
    };
  };

  meta = with lib; {
    description = "Low-level library for installing a Python package from a wheel distribution";
    homepage = "https://github.com/pypa/installer";
    changelog = "https://github.com/pypa/installer/blob/${src.rev}/docs/changelog.md";
    license = licenses.mit;
    maintainers = [ maintainers.cpcloud ];
    teams = [ teams.python ];
  };
}
